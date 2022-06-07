# Class arc_ce::arex::ws::jobs
# Configures the arex/ws/jobs block in arc.conf
class arc_ce::arex::ws::jobs(
  Boolean $enable = false,
  Boolean $allownew = true,
  Array[String] $allownew_override = [],
  Array[Arc_ce::Access] $access = [],
  Array[String] $denyaccess = [],
  Array[String] $allowaccess = [],
  Integer $maxjobdesc = 5242880,
) {

  if $enable {
    concat::fragment { 'arc.conf_arex_ws_jobs':
      target  => '/etc/arc.conf',
      content => template("${module_name}/arex/ws_jobs.erb"),
      order   => 21,
    }
  }

}
