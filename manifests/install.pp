class arc_ce::install {
  package { 'nordugrid-arc-compute-element':
    ensure  => present,
  }

  include arc_ce::lcmaps::install
  include arc_ce::lcas::install
}
