class arc_ce::config::infosys (
  $cores_per_worker   = 16,
  $domain_name        = 'GOCDB-SITENAME',
  $enable_glue1       = false,
  $enable_glue2       = true,
  $glue_site_web      = 'http://www.bristol.ac.uk/physics/research/particle/',
  $hepspec_per_core   = '11.17',
  $log_directory      = '/var/log/arc',
  $resource_location  = 'Bristol, UK',
  $resource_latitude  = '51.4585',
  $resource_longitude = '-02.6021',) {
  concat::fragment { 'arc.conf_infosys':
    target  => '/etc/arc.conf',
    content => template("${module_name}/infosys.erb"),
    order   => 05,
  }

}