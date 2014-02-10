class arc_ce::install {
  package { 'nordugrid-arc-compute-element':
    ensure  => present,
    require => [Class['arc_ce::repositories'], Yumrepo['EGI-trustanchors'],],
  }

  include arc_ce::lcmaps::install
  include arc_ce::lcas::install
}
