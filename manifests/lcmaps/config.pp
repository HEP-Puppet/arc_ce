class arc_ce::lcmaps::config (
  $argus_server) {
  file { '/etc/lcmaps/lcmaps.db':
    ensure  => present,
    content => template("${module_name}/lcmaps.db.erb"),
  }
}