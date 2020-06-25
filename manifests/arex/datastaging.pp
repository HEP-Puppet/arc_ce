# Class arc_ce::arex::datastaging
class arc_ce::arex::datastaging(
  Boolean $enable = false,
  Arc_ce::LogLevel $ds_loglevel = $::arc_ce::arex::arexloglevel,
  Optional[Stdlib::Unixpath] $logfile = undef,
  Stdlib::Unixpath $statefile = "${::arc_ce::arex::controldir}/dtr.state",
  Boolean $usehostcert = false,
  Integer $maxtransfertries = 10,
  Boolean $passivetransfer = true,
  Array[Stdlib::Port::Unprivileged,2,2] $globus_tcp_port_range = $::arc_ce::config::globus_tcp_port_range,
  Array[Stdlib::Port::Unprivileged,2,2] $globus_udp_port_range = $::arc_ce::config::globus_udp_port_range,
  Boolean $httpgetpartial = false,
  Optional[Array[Integer,4,4]] $speedcontrol = undef,
  Integer $maxdelivery = 10,
  Integer $maxprocessor = 10,
  Integer $maxemergency = 1,
  Integer $maxprepared = 200,
  Optional[Arc_ce::SharePolicy] $sharepolicy = undef,
  Hash[String, Integer] $sharepriority = {},
) {

  if $enable {
    concat::fragment { 'arc.conf_arex_datastaging':
      target  => '/etc/arc.conf',
      content => template("${module_name}/arex/datastaging.erb"),
      order   => 19,
    }
  }

}
