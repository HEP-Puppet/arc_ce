class arc_ce::config (
  $cluster_alias     = 'MINIMAL Computing Element',
  $cluster_comment   = 'This is a minimal out-of-box CE setup',
  $resource_location = 'Lund, Sweden',
  $mail              = 'gridmaster@hep.lu.se',
  $lrms              = 'fork',
  $enable_glue1      = false,
  $enable_glue2      = true,
  $log_directory     = '/var/log/arc',
  $run_directory     = '/var/run/arc',
  $domain_name       = 'GOCDB-SITENAME',
  $session_dir       = ['/var/spool/arc/grid00'],
  $queue_defaults    = {
  }
  ,
  $queues            = {
  }
  ,
  $use_argus         = false,
  $argus_server      = 'argus.example.com',
  $apel_testing      = true,
  $hepspec_per_core  = '11.17',
  $authorized_vos    = [
    'alice',
    'atlas',
    'cms',
    'ops',
    'dteam',
    'gridpp',
    'ilc',
    'lhcb',
    'vo.landslides.mossaic.org',
    'vo.southgrid.ac.uk']) {
  file { $session_dir: ensure => directory, }

  concat { '/etc/arc.conf': require => Package['nordugrid-arc-compute-element'], 
  }

  concat::fragment { 'arc.conf_common':
    target  => '/etc/arc.conf',
    content => template("${module_name}/common.erb"),
    order   => 01,
  }

  concat::fragment { 'arc.conf_gridmanager':
    target  => '/etc/arc.conf',
    content => template("${module_name}/grid-manager.erb"),
    order   => 02,
  }

  concat::fragment { 'arc.conf_group':
    target  => '/etc/arc.conf',
    content => template("${module_name}/group.erb"),
    order   => 03,
  }

  concat::fragment { 'arc.conf_gridftpd':
    target  => '/etc/arc.conf',
    content => template("${module_name}/gridftpd.erb"),
    order   => 04,
  }

  concat::fragment { 'arc.conf_infosys':
    target  => '/etc/arc.conf',
    content => template("${module_name}/infosys.erb"),
    order   => 05,
  }

  concat::fragment { 'arc.conf_cluster':
    target  => '/etc/arc.conf',
    content => template("${module_name}/cluster.erb"),
    order   => 06,
  }

  create_resources('arc_ce::queue', $queues, $queue_defaults)

  class { 'arc_ce::lcmaps::config': argus_server => $argus_server }

  class { 'arc_ce::lcas::config': }
}