# Class: arc_ce
# Sets up the configuration file and file dependencies.
class arc_ce::config (
  $allow_new_jobs      = 'yes',
  $accounting_archives = '/var/run/arc/urs',
  $apel_testing        = true,
  $apel_urbatch          = '1000',
  $apply_fixes         = '',
  $arex_port           = '60000',
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
  $benchmark_type      = 'HEPSPEC',
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
    'NodeMemory'    => '1024',
    'totalcpus'     => '42',
  }
  ,
  $cluster_is_homogenious       = true,
  $cluster_nodes_private        = true,
  $cluster_owner       = 'Bristol HEP',
  $cluster_registration_country = 'UK',
  $cluster_registration_name    = 'clustertoukglasgow',
  $cluster_registration_target  = 'svr019.gla.scotgrid.ac.uk',
  $cores_per_worker    = '16',
  $cpu_scaling_reference_si00 = '3100',
  $debug               = false,
  $domain_name         = 'GOCDB-SITENAME',
  $enable_glue1        = false,
  $enable_glue2        = true,
  $globus_port_range   = [50000, 52000],
  $glue_site_web       = 'http://www.bristol.ac.uk/physics/research/particle/',
  $gridftp_max_connections      = '100',
  $hepspec_per_core    = '11.17',
  $infosys_registration = {
    'clustertouk1' => {
      targethostname => 'index1.gridpp.rl.ac.uk',
      targetport => '2135',
      targetsuffix => 'Mds-Vo-Name=UK,o=grid',
      regperiod => '120',},

    'clustertouk2' => {
       targethostname => 'index2.gridpp.rl.ac.uk',
       targetport => '2135',
       targetsuffix => 'Mds-Vo-Name=UK,o=grid',
       regperiod => '120',}
   },

  $log_directory       = '/var/log/arc',
  $lrms                = 'fork',
  $mail                = 'gridmaster@hep.lu.se',
  $queues              = {},
  $resource_location   = 'Bristol, UK',
  $resource_latitude   = '51.4585',
  $resource_longitude  = '-02.6021',
  $run_directory       = '/var/run/arc',
  $session_dir         = ['/var/spool/arc/grid00'],
  $setup_RTEs          = true,
  $use_argus           = false,
  $hostname            = $::fqdn,) {
  file { $session_dir: ensure => directory, }

  file { $cache_dir: ensure => directory, }

  concat { '/etc/arc.conf': require => Package['nordugrid-arc-compute-element'],
    notify => Service['a-rex'],
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

  concat::fragment { 'arc.conf_queues':
    target  => '/etc/arc.conf',
    content => template("${module_name}/queues.erb"),
    order   => 07,
  }

  # Added to use the same pid files as configured in /etc/arc.conf
  file { '/etc/logrotate.d/nordugrid-arc-arex':
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/nordugrid-arc-arex.erb"),
    require => Package['nordugrid-arc-compute-element'],
  }

  file { '/etc/logrotate.d/nordugrid-arc-gridftpd':
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/nordugrid-arc-gridftpd.erb"),
    require => Package['nordugrid-arc-compute-element']
  }

  class { 'arc_ce::lcmaps::config': argus_server => $argus_server }

  class { 'arc_ce::lcas::config': }

  # plugin to set a default runtime environment
  file { '/usr/local/bin/default_rte_plugin.py':
    ensure => present,
    source => "puppet:///modules/${module_name}/default_rte_plugin.py",
    mode   => '0755',
  }

  # set up runtime environments
  if $setup_RTEs {
    class {'arc_ce::runtime_env':}
  }

  # apply manual fixes
  # for details check fixes.md
  if $apply_fixes {
    file { '/usr/share/arc/submit-condor-job':
      source => "puppet:///modules/${module_name}/fixes/submit-condor-job.ARC.$apply_fixes",
      backup => true,
    }

    file { '/usr/share/arc/Condor.pm':
      source => "puppet:///modules/${module_name}/fixes/Condor.pm.ARC.$apply_fixes",
      backup => true,
    }

    file { '/usr/share/arc/glue-generator.pl':
      source => "puppet:///modules/${module_name}/fixes/glue-generator.pl.ARC.$apply_fixes",
      backup => true,
    }
  }
}
