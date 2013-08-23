class arc_ce::config (
  $cluster_alias = 'MINIMAL Computing Element',
  $cluster_comment = 'This is a minimal out-of-box CE setup',
  $node_cpu          = 2,
  $resource_location = 'Lund, Sweden',
  $mail              = 'gridmaster@hep.lu.se',
  $lrms              = 'fork',
  $enable_glue1      = false,
  $enable_glue2      = true,  
  $log_directory     = '/var/log/arc',
  $run_directory     = '/var/run/arc',
  $domain_name       = 'ARC-TESTDOMAIN') {
  file { '/etc/arc.conf':
    ensure  => present,
    content => template("${module_name}/arc.cfg.erb"),
    require => Package['nordugrid-arc-compute-element'],
  }
}