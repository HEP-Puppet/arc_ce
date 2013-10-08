class arc_ce::config (
  $apel_testing            = true,
  $argus_server            = 'argus.example.com',
  $authorized_vos          = [
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
  $cluster_alias           = 'MINIMAL Computing Element',
  $cluster_comment         = 'This is a minimal out-of-box CE setup',
  $cluster_cpudistribution = ['16cpu:12'],
  $cluster_description     = {
    'OSFamily'      => 'linux',
    'OSName'        => 'ScientificSL',
    'OSVersion'     => '6.4',
    'CPUVendor'     => 'AMD',
    'CPUClockSpeed' => '3100',
    'CPUModuel'     => 'AMD Opteron(tm) Processor 4386',
  }
  ,
  $cluster_is_homogenious  = true,
  $cluster_nodes_private   = true,
  $cores_per_worker        = 16,
  $domain_name             = 'GOCDB-SITENAME',
  $enable_glue1            = false,
  $enable_glue2            = true,
  $glue_site_web           = 'http://www.bristol.ac.uk/physics/research/particle/',
  $hepspec_per_core        = '11.17',
  $log_directory           = '/var/log/arc',
  $lrms                    = 'fork',
  $mail                    = 'gridmaster@hep.lu.se',
  $queue_defaults          = {
  }
  ,
  $queues                  = {
  }
  ,
  $resource_location       = 'Bristol, UK',
  $resource_latitude       = '51.4585',
  $resource_longitude      = '-02.6021',
  $run_directory           = '/var/run/arc',
  $session_dir             = ['/var/spool/arc/grid00'],
  $use_argus               = false,) {
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

  class { 'arc_ce::config::infosys':
    cores_per_worker   => $cores_per_worker,
    domain_name        => $domain_name,
    enable_glue1       => $enable_glue1,
    enable_glue2       => $enable_glue2,
    glue_site_web      => $glue_site_web,
    hepspec_per_core   => $hepspec_per_core,
    log_directory      => $log_directory,
    resource_latitude  => $resource_latitude,
    resource_location  => $resource_location,
    resource_longitude => $resource_longitude,
  }

  class { 'arc_ce::config::cluster':
    cluster_alias           => $cluster_alias,
    cluster_comment         => $cluster_comment,
    cluster_cpudistribution => $cluster_cpudistribution,
    cluster_description     => $cluster_description,
    cluster_is_homogenious  => $cluster_is_homogenious,
    cluster_location        => $resource_location,
    cluster_nodes_private   => $cluster_nodes_private,
    cluster_support         => $mail,
  }

  create_resources('arc_ce::queue', $queues, $queue_defaults)

  class { 'arc_ce::lcmaps::config': argus_server => $argus_server }

  class { 'arc_ce::lcas::config': }

  # for GLITE, just an empty file
  file { '/etc/arc/runtime/ENV': ensure => directory, } -> file { '/etc/arc/runtime/ENV/GLITE'
  : ensure => present }

  # apply manual fixes:
  file { '/usr/share/arc/submit-condor-job':
    ensure => present,
    source => "puppet:///modules/${module_name}/fixes/submit-condor-job",
  }
}
