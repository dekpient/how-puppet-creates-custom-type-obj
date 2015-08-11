class how-puppet-creates-custom-type-obj {

  stuff { 'hi':
  	ensure      => 'present',
  	color       => 'red',
  	smell_level => 9
  }

  stuff { 'magic':
  	ensure => 'present',
  	color  => 'blue',
  	names  => ['ing', 'dekpient']
  }

  wait { 'a while':
    ensure => 'present',
    sec    => 2
  }

  Wait['a while'] -> Stuff['magic']

}
