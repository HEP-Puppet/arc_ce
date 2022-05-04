class arc_ce::arex::ws(
  Boolean $enable = false,
  Stdlib::HTTPSUrl $wsurl = "https://${facts['networking']['fqdn']}:443/arex",
  Stdlib::Unixpath $logfile = '/var/log/arc/ws-interface.log',
  Integer $max_job_control_requests = 100,
  Integer $max_infosys_requests = 1,
  Integer $max_data_transfer_requests = 100,
  String $allownew = 'yes',
  Array[String] $allownew_override = [],
  Array[String] $allowaccess = [],
  Array[String] $denyaccess = [],
  Optional[Integer] $maxjobdesc = undef,
) {

  if $enable {

    concat::fragment { 'arc.conf_ws':
      target  => '/etc/arc.conf',
      content => template("${module_name}/ws/common.erb"),
      order   => 20,
    }

    # ws/jobs block, uses order 21
    concat::fragment { 'arc.conf_ws_jobs':
      target  => '/etc/arc.conf',
      content => template("${module_name}/ws/jobs.erb"),
      order   => 21,
    }

    # ws/cache block, uses order 22
    #contain 'arc_ce::ws::cache

    # ws/candypond block, uses order 23
    #contain 'arc_ce::ws::candypond'

    # ws/argus block, uses order 24
    #contain 'arc_ce::ws::argus'

    # ws/publicinfo block, uses order 28
    #contain 'arc_ce::ws::publicinfo'

  }

}
