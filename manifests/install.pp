class arc_ce::install (
  $nordugrid_repo_version = $arc_ce::params::nordugrid_repo_version,
  $use_nordugrid          = $arc_ce::params::use_nordugrid_repo,
  $use_emi                = $arc_ce::params::use_emi_repo,
  $emi_repo_version       = $arc_ce::params::emi_repo_version,) inherits arc_ce::params {
  class { "arc_ce::repositories":
    nordugrid_repo_version => $nordugrid_repo_version,
    use_nordugrid          => $use_nordugrid,
    use_emi                => $use_emi,
    emi_repo_version       => $emi_repo_version,
  }

  package { "nordugrid-arc-compute-element":
    ensure  => present,
    require => Class["arc_ce::repositories"],
  }
}