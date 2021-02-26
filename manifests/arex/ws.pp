class arc_ce::arex::ws(
  Boolean $enable = false,
  Stdlib::HTTPSUrl $wsurl = "https://${facts['networking']['fqdn']}:443/arex",
  Stdlib::Unixpath $logfile = '/var/log/arc/ws-interface.log',
  Integer $max_job_control_requests = 100,
  Integer $max_infosys_requests = 1,
  Integer $max_data_transfer_requests = 100,
) {

  if $enable {

    concat::fragment { 'arc.conf_ws':
      target  => '/etc/arc.conf',
      content => template("${module_name}/ws/common.erb"),
      order   => 20,
    }

    # ws/jobs block, uses order 21
    #contain 'arc_ce::ws::jobs'

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
