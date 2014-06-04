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
  $install_from_repository      = 'nordugrid',
  $manage_repository = true, #if set to no, no repository will be setup
  $allow_new_jobs      = 'yes',
  $enable_firewall     = true,
  $apel_testing        = true,
  $apel_urbatch        = '1000',
  $apply_fixes         = false,
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
  $cache_dir           = ['/var/cache/arc'],
  $cluster_alias       = 'MINIMAL Computing Element',
  $cluster_comment     = 'This is a minimal out-of-box CE setup',
  $cluster_cpudistribution      = ['16cpu:12'],
  $cluster_description = {
    'OSFamily'      => 'linux',
    'OSName'        => 'ScientificSL',
    'OSVersion'     => '6.4',
    'OSVersionName' => 'Carbon',
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
  $cores_per_worker    = '16',
  $cpu_scaling_reference_si00 = '3100',
  $debug               = true,
  $domain_name         = 'GOCDB-SITENAME',
  $enable_glue1        = false,
  $enable_glue2        = true,
  $enable_trustanchors = true,
  $glue_site_web       = 'http://www.bristol.ac.uk/physics/research/particle/',
  $globus_port_range   = [50000, 52000],
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
  if $manage_repository {
    if $install_from_repository == 'nordugrid' {
      class { 'arc_ce::repositories':
        use_nordugrid          => true,
        nordugrid_repo_version => '13.11',
        enable_trustanchors    => $enable_trustanchors
      }
    } else {
      class { 'arc_ce::repositories':
        use_emi          => true,
        emi_repo_version => '3',
        enable_trustanchors    => $enable_trustanchors
      }
    }
    Class['arc_ce::repositories'] ~> Class[Arc_ce::Install]
    Class['arc_ce::repositories'] ~> Package[nordugrid-arc-compute-element]
    Class['arc_ce::repositories'] ~> Yumrepo['EGI-trustanchors']
  }

  class { 'arc_ce::install':  }

  class { 'arc_ce::config':
    allow_new_jobs      => $allow_new_jobs,
    apel_testing        => $apel_testing,
    apel_urbatch        => $apel_urbatch,
    apply_fixes         => $apply_fixes,
    arex_port           => $arex_port,
    argus_server        => $argus_server,
    authorized_vos      => $authorized_vos,
    benchmark_results   => $benchmark_results,
    cache_dir           => $cache_dir,
    cluster_alias       => $cluster_alias,
    cluster_comment     => $cluster_comment,
    cluster_cpudistribution      => $cluster_cpudistribution,
    cluster_description => $cluster_description,
    cluster_is_homogenious       => $cluster_is_homogenious,
    cluster_nodes_private        => $cluster_nodes_private,
    cluster_owner       => $cluster_owner,
    cores_per_worker    => $cores_per_worker,
    cpu_scaling_reference_si00 => $cpu_scaling_reference_si00,
    domain_name         => $domain_name,
    debug               => $debug,
    enable_glue1        => $enable_glue1,
    enable_glue2        => $enable_glue2,
    globus_port_range   => $globus_port_range,
    glue_site_web       => $glue_site_web,
    gridftp_max_connections      => $gridftp_max_connections,
    hepspec_per_core    => $hepspec_per_core,
    infosys_registration => $infosys_registration,
    log_directory       => $log_directory,
    lrms                => $lrms,
    mail                => $mail,
    queue_defaults      => $queue_defaults,
    queues              => $queues,
    resource_latitude   => $resource_latitude,
    resource_location   => $resource_location,
    resource_longitude  => $resource_longitude,
    run_directory       => $run_directory,
    session_dir         => $session_dir,
    setup_RTEs          => $setup_RTEs,
    use_argus           => $use_argus,
    require             => Class['arc_ce::install'],
  }
   if $enable_firewall {
  class { 'arc_ce::firewall':
    globus_port_range => $globus_port_range,
  }
 }
  class { 'arc_ce::services':
    require => Class['arc_ce::config'],
  }

}
