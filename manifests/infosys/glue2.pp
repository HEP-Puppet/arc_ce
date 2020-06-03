# Class arc_ce::infosys::glue2
# Configures the infosys::glue2 block in arc.conf
class arc_ce::infosys::glue2(
  String $admindomain_name = 'UNDEFINEDVALUE',
  Optional[String] $admindomain_description = undef,
  Optional[Variant[Stdlib::HTTPUrl,Stdlib::HTTPSUrl]] $admindomain_www = undef,
  Boolean $admindomain_distributed = false,
  Optional[String] $admindomain_owner = undef,
  Optional[String] $admindomain_otherinfo = undef,
  Arc_ce::QualityLevel $computingservice_qualitylevel = 'production',
  Boolean $enable_ldap = false,
  Boolean $ldap_showactivities = false,
) {

  concat::fragment { 'arc.conf_infosys_glue2':
    target  => '/etc/arc.conf',
    content => template("${module_name}/infosys/glue2.erb"),
    order   => 36,
  }

  if $enable_ldap {
    concat::fragment { 'arc.conf_infosys_glue2_ldap':
      target  => '/etc/arc.conf',
      content => template("${module_name}/infosys/glue2_ldap.erb"),
      order   => 37,
    }
  }

}
