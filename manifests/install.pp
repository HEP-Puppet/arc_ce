class arc_ce::install (
  $from_repository = 'nordugrid',) {
  package { 'nordugrid-arc-compute-element':
    ensure  => present,
    require => [
      Yumrepo[$from_repository],
      Yumrepo['EGI-trustanchors']],
  }

  include arc_ce::lcmaps::install
  include arc_ce::lcas::install
}
