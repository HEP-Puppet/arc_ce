# Class arc_ce::lcmaps::config
# Configures lcmaps
class arc_ce::lcmaps::config(
  String $argus_server,
  Stdlib::Unixpath $x509_cert_dir = $::arc_ce::config::x509_cert_dir,
  Stdlib::Unixpath $x509_host_cert = $::arc_ce::config::x509_host_cert,
  Stdlib::Unixpath $x509_host_key = $::arc_ce::config::x509_host_key,
) {

  file { '/etc/lcmaps/lcmaps.db':
    ensure  => 'present',
    content => template("${module_name}/lcmaps.db.erb"),
    require => Package['lcmaps'],
  }

}
