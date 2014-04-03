# Class: arc_ce
# Sets up the configuration file and file dependencies.
class arc_ce::config (
  $apel_testing        = true,
  $apply_fixes         = false,
  $arex_port           = 60000,
  $argus_server        = 'argus.example.com',
  $authorized_vos      = [
    'alice',
    'atlas',
    'cms',
    'ops',
    'dteam',
    'gridpp',
    'ilc',
    'lhcb',
    'vo.landslides.mossaic.org',
    'vo.southgrid.ac.uk'],
  $benchmark_results   = [
    'SPECINT2000 222',
    'SPECFP2000 333',
    'HEPSPEC2006 444'],
  $cache_dir           = ['/var/cache/arc'],
  $cluster_alias       = 'MINIMAL Computing Element',
  $cluster_comment     = 'This is a minimal out-of-box CE setup',
  $cluster_cpudistribution      = ['16cpu:12'],
  $cluster_description = {
    'OSFamily'      => 'linux',
    'OSName'        => 'ScientificSL',
    'OSVersion'     => '6.4',
    'CPUVendor'     => 'AMD',
    'CPUClockSpeed' => '3100',
    'CPUModel'      => 'AMD Opteron(tm) Processor 4386',
    'NodeMemory'    => 1024,
    'totalcpus'     => 42,
  }
  ,
  $cluster_is_homogenious       = true,
  $cluster_nodes_private        = true,
  $cluster_owner       = 'Bristol HEP',
  $cluster_registration_country = 'UK',
  $cluster_registration_name    = 'clustertoukglasgow',
  $cluster_registration_target  = 'svr019.gla.scotgrid.ac.uk',
  $cores_per_worker    = 16,
  $debug               = true,
  $domain_name         = 'GOCDB-SITENAME',
  $enable_glue1        = false,
  $enable_glue2        = true,
  $globus_port_range   = [50000, 52000],
  $glue_site_web       = 'http://www.bristol.ac.uk/physics/research/particle/',
  $gridftp_max_connections      = 100,
  $hepspec_per_core    = '11.17',
  $log_directory       = '/var/log/arc',
  $lrms                = 'fork',
  $mail                = 'gridmaster@hep.lu.se',
  $queue_defaults      = {
  }
  ,
  $queues              = {
  }
  ,
  $resource_location   = 'Bristol, UK',
  $resource_latitude   = '51.4585',
  $resource_longitude  = '-02.6021',
  $run_directory       = '/var/run/arc',
  $session_dir         = ['/var/spool/arc/grid00'],
  $setup_RTEs          = true,
  $use_argus           = false,) {
  file { $session_dir: ensure => directory, }

  file { $cache_dir: ensure => directory, }

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

  # create folders for runtime environments
  file { [
    '/etc/arc/runtime/',
    '/etc/arc/runtime/ENV']: ensure => directory, }

  # plugin to set a default runtime environment
  file { '/usr/local/bin/default_rte_plugin.py':
    ensure => present,
    source => "puppet:///modules/${module_name}/default_rte_plugin.py",
    mode   => 755,
  }

  # set up runtime environments
  if $setup_RTEs {
    file { '/etc/arc/runtime/ENV/GLITE':
      ensure  => present,
      source  => "puppet:///modules/${module_name}/RTEs/GLITE",
      require => File['/etc/arc/runtime/ENV'],
    }

    file { '/etc/arc/runtime/ENV/PROXY':
      ensure  => present,
      source  => "puppet:///modules/${module_name}/RTEs/PROXY",
      require => File['/etc/arc/runtime/ENV'],
    }
  }

  # apply manual fixes
  # for details check fixes.md
  if $apply_fixes {
    file { '/usr/share/arc/submit-condor-job':
      source => "puppet:///modules/${module_name}/fixes/submit-condor-job.ARC.4.0.0",
      backup => true,
    }

    file { '/usr/share/arc/Condor.pm':
      source => "puppet:///modules/${module_name}/fixes/Condor.pm.ARC.4.0.0",
      backup => true,
    }
  }
}
