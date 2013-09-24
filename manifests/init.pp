# Class: arc_ce
#
# This module manages arc_ce
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class arc_ce (
  $install_from_repository = 'nordugrid',
  $cluster_alias           = 'MINIMAL Computing Element',
  $cluster_comment         = 'This is a minimal out-of-box CE setup',
  $resource_location       = 'Lund, Sweden',
  $mail                    = 'gridmaster@hep.lu.se',
  $lrms                    = 'fork',
  $enable_glue1            = false,
  $enable_glue2            = true,
  $log_directory           = '/var/log/arc',
  $run_directory           = '/var/run/arc',
  $domain_name             = 'ARC-TESTDOMAIN') {
  if $install_from_repository == 'nordugrid' {
    class { 'arc_ce::repositories':
      use_nordugrid          => true,
      nordugrid_repo_version => '13.02',
    }
  } else {
    class { 'arc_ce::repositories':
      use_emi          => true,
      emi_repo_version => 3,
    }
  }

  class { 'arc_ce::install':
    from_repository => $install_from_repository,
  }

  class { 'arc_ce::config':
    cluster_alias     => $cluster_alias,
    cluster_comment   => $cluster_comment,
    resource_location => $resource_location,
    mail              => $mail,
    lrms              => $lrms,
    enable_glue1      => $enable_glue1,
    enable_glue2      => $enable_glue2,
    log_directory     => $log_directory,
    run_directory     => $run_directory,
    domain_name       => $domain_name,
  }

  class { 'arc_ce::firewall':
  }

  class { 'arc_ce::services':
  }

}
