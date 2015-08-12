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