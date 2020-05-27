# Class arc_ce::arex::jura
# Configures the jura blocks in arc.conf
class arc_ce::arex::jura(
  Boolean $enable = false,
  Stdlib::Unixpath $logfile = '/var/log/arc/jura.log',
  Arc_ce::LogLevel $jura_loglevel = 'INFO',
  #vomsless_vo
  Optional[Stdlib::Unixpath] $vo_group = undef, # misusing unixpath here because FQANs have the same pattern
  Integer $urdelivery_frequency = 3600,
  Stdlib::Unixpath $x509_host_key = $::arc_ce::config::x509_host_key,
  Stdlib::Unixpath $x509_host_cert = $::arc_ce::config::x509_host_cert,
  Stdlib::Unixpath $x509_cert_dir = $::arc_ce::config::x509_cert_dir,
  Hash $apel_targets = {},
) {

  if $enable {
    concat::fragment { 'arc.conf_arex_jura':
      target  => '/etc/arc.conf',
      content => template("${module_name}/arex/jura.erb"),
      order   => 25,
    }

    # create sgas targets, reservered order 26

    # create apel targets, uses order 27
    create_resources('arc_ce::arex::jura_apel', $apel_targets)
  }

}
