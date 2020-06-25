# Class arc_ce::gridftpd
# Configures the gridftpd blocks in arc.conf
class arc_ce::gridftpd(
  Boolean $enable = false,
  String $user = 'root',
  String $group = 'root',
  Arc_ce::LogLevel $gridftpd_loglevel = 'INFO',
  Stdlib::Unixpath $logfile = '/var/log/arc/gridftpd.log',
  Stdlib::Unixpath $pidfile = '/var/run/gridftpd.pid',
  Stdlib::Port::Unprivileged $port = 2811,
  Boolean $allowencryption = false,
  Boolean $allowactivedata = true,
  Integer $maxconnections = 100,
  Integer $defaultbuffer = 65536,
  Integer $maxbuffer = 655360,
  Array[Stdlib::Port::Unprivileged,2,2] $globus_tcp_port_range = $::arc_ce::config::globus_tcp_port_range,
  Array[Stdlib::Port::Unprivileged,2,2] $globus_udp_port_range = $::arc_ce::config::globus_udp_port_range,
  Optional[Stdlib::Host] $firewall = undef,
  Stdlib::Unixpath $x509_host_key = $::arc_ce::config::x509_host_key,
  Stdlib::Unixpath $x509_host_cert = $::arc_ce::config::x509_host_cert,
  Stdlib::Unixpath $x509_cert_dir = $::arc_ce::config::x509_cert_dir,
) {

  if $enable {

    Package <| tag == 'arc-package-gridftpd' |>
    Service <| tag == 'arc-service-gridftpd' |>

    concat::fragment { 'arc.conf_gridftpd':
      target  => '/etc/arc.conf',
      content => template("${module_name}/gridftpd/common.erb"),
      order   => 30,
    }

    # gridftpd/jobs block, uses order 31
    contain 'arc_ce::gridftpd::jobs'

    # gridftpd/filedir block, uses order 32
    #contain 'arc_ce::gridftpd::filedir'

  }

}
