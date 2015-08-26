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

  boo { 'db':
    refresh_session => "Stuff[magic]"
  }

  boo { 'join':
    refresh_session => [Stuff['magic'], Stuff['hi']]
  }

  # magic first but boo should reload magic
  Stuff['magic'] -> Boo['db']
  Stuff['magic'] -> Boo['join']
  Wait['a while'] -> Stuff['magic']
}
