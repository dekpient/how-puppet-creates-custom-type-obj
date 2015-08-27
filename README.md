## How Puppet Creates Custom Type/Provider Objects

```
├── lib
│   ├── puppet
│   │   ├── provider
│   │   │   ├── stuff
│   │   │   │   └── rubbish.rb **
│   │   │   └── wait
│   │   │       └── ruby.rb
│   │   └── type
│   │       ├── stuff.rb **
│   │       └── wait.rb
│   └── sneak.rb
└── manifests
    └── init.pp
```

### Must Read

- [Puppet Extension Points - Part 2](http://www.masterzen.fr/2011/11/02/puppet-extension-point-part-2/)

### Run & Read

- `puppet apply --modulepath=.. tests/init.pp`

- `puppet apply --modulepath=.. tests/init.pp --verbose`

- `puppet apply --modulepath=.. tests/init.pp --debug`

### Things I Learned

0. In the code block passed to `provide`, `newtype`, `newparam`, or `newproperty`, `self` is the `Class` object.

1. Types, Providers, `param`s, and `property`s are defined before the catalog is compiled. Each block is run once.

```ruby
Puppet::Type::Stuff # the resource type class
Puppet::Type::Stuff::ParameterName # the param class
Puppet::Type::Stuff::ParameterSmell_level
Puppet::Type::Stuff::ParameterColor
Puppet::Type::Stuff::Names # the property
Puppet::Type::Stuff::ProviderRubbish # the provider
```

2. After the catalog is compiled, the resource type object is created. All params and properties and its provider are then created as part of the initialization of the resource type object. (It looks like type objects are created in the order they're defined in the manifest.)

3. Param and property values are validated and munged during initialization.

4. Any params/properties without a default value that do not get used in the manifest are not created as objects.

5. Each resource type object has its own provider object.

6. Methods on the provider are only called when the state of the resource is being evaluated.

7. Evaluation process doesn't occur until it should be done according to the relationship defined in the manifests (and Puppet's internal ordering algorithm - SHA1 of namevar?). That means property's methods like `insync?` or provider's methods like `exists?` won't be called until then. (Kinda good for (cached) instance variable lazy loading)

8. If a resource doesn't exist and should be created, the `create` method must take care of setting all the properties. Their setter methods will not be called.

# namevar VS title ...and aliases?

- I think of namevar as the main primary key to the resource object in a map
- The title is just an alias, but an alias must refer to EXACTLY ONE the resource object (an objects can many more aliases)
- Most types use the title as the namevar if the namevar is omitted

Basically,

- there must be one and ONLY one resource with a particular namevar.
- if there is a resource of type A that uses title 'B', NO other resource of the same type can use that title again

...trying to declare another resource with the same namevar (regardless of how/if you define the title)? => BOOM

```
  file { 'hi': path => '/tmp/lol' }
  file { '/tmp/lol': }
=> Error: Duplicate declaration: File[/tmp/lol] is already declared ... cannot redeclare
```

...trying to alias a different title to resource with same namevar? => BOOM

```
  file { 'hi':       path => '/tmp/lol' }
  file { 'hi again': path => '/tmp/lol' }
=> Error: Cannot alias File[hi again] to ["/tmp/lol"] ... resource ["File", "/tmp/lol"] already declared
```

...trying to use the same alias for different resource? => Double BOOM

```
  file { 'hi': path => '/tmp/lol' }
  file { 'hi': path => '/tmp/more_lol' }
=> Error: Duplicate declaration: File[hi] is already declared ... cannot redeclare 
=> Error: Duplicate declaration: File[hi] is already declared ... cannot redeclare
```

So, if both are provided on each declared resouce, they both must be different.

```
  file { 'hi:        path => '/tmp/lol' }
  file { 'hi again': path => '/tmp/more_lol' }
```