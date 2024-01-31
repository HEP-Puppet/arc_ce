# Class arc_ce::arex::ws::argus
# Configures the arex/ws/argus block in arc.conf
class arc_ce::arex::ws::argus (
  Boolean $enable = false,
  Optional[String] $arguspep_endpoint = undef,
  Arc_ce::ArgusPepProfile $arguspep_profile = 'emi',
  Boolean $arguspep_usermap = false,
  Optional[String] $arguspdp_endpoint = undef,
  Arc_ce::ArgusPdpProfile $arguspdp_profile = 'emi',
  Boolean $arguspdp_acceptnotapplicable = false,
) {
  if $enable {
    concat::fragment { 'arc.conf_arex_ws_argus':
      target  => '/etc/arc.conf',
      content => template("${module_name}/arex/ws_argus.erb"),
      order   => 24,
    }
  }
}
