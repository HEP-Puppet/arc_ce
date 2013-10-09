class arc_ce::lcmaps::install {
  package { [
    'lcmaps',
    'lcmaps-plugins-basic',
    'lcmaps-plugins-c-pep',
    'lcmaps-plugins-voms',
    'lcmaps-plugins-verify-proxy']:
    ensure => present,
  }
}