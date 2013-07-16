class arc_ce::users {
  group {
      'grid':
        ensure => present,
        name   => 'grid',
        gid => 13370,
    }
    
  user{'griduser1':
    ensure     => present,
      comment    => 'grid user for tests',
      password   => '!!',
      shell      => "/bin/bash",
      gid        => 13370,
      home       => '/home/griduser1',
      managehome => true,
  }
  Group['grid'] -> User['griduser1']
}
