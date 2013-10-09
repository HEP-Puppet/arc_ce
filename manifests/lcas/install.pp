class arc_ce::lcas::install {
  package { [
    'lcas',
    'lcas-plugins-basic',
    'lcas-plugins-voms']:
    ensure => present,
  }
}