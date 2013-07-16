class arc_ce::config (
  $node_cpu          = 2,
  $resource_location = "Lund, Sweden",
  $mail              = "gridmaster@hep.lu.se",
  $lrms              = "fork",
  $session_dir       = "/tmp/grid",
  $control_dir       = "/tmp/jobstatus",
  $cache_dir         = "/tmp/cache",) {
  file { '/etc/arc.conf':
    ensure  => present,
    content => template("${module_name}/sender.cfg.erb"),
    require => Package['nordugrid-arc-compute-element'],
  }
}