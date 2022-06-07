# Class arc_ce::arex::ws::publicinfo
# Configures the arex/ws/publicinfo block in arc.conf
class arc_ce::arex::ws::publicinfo(
  Boolean $enable = false,
  Array[Arc_ce::Access] $access = [],
  Array[String] $allowaccess = [],
  Array[String] $denyaccess = [],
) {

  if $enable {
    concat::fragment { 'arc.conf_ws_publicinfo':
      target  => '/etc/arc.conf',
      content => template("${module_name}/arex/ws_publicinfo.erb"),
      order   => 28,
    }
  }

}
