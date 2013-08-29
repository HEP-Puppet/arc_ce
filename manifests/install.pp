class arc_ce::install (
  $from_repository = 'nordugrid',) {
  package { 'nordugrid-arc-compute-element':
    ensure  => present,
    require => [
      Yumrepo[$from_repository],
      Yumrepo['EGI-trustanchors']],
  }
}