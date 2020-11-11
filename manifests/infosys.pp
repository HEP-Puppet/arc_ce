# Class arc_ce::infosys
# Configures the infosys block in arc.conf
class arc_ce::infosys(
  Stdlib::Unixpath $logfile = '/var/log/arc/infoprovider.log',
  Arc_ce::LogLevel $infosys_loglevel = 'INFO',
  Integer $validity_ttl = 10800,
  Boolean $enable_nordugrid = false,
  Boolean $enable_glue1 = false,
) {

  concat::fragment { 'arc.conf_infosys':
    target  => '/etc/arc.conf',
    content => template("${module_name}/infosys/common.erb"),
    order   => 33,
  }

  # infosys/ldap block, uses order 34
  contain 'arc_ce::infosys::ldap'

  # infosys/nordugrid block, order 35
  if $enable_nordugrid {
    concat::fragment { 'arc.conf_infosys_nordugrid':
      target  => '/etc/arc.conf',
      content => "[infosys/nordugrid]\n\n",
      order   => 35,
    }
  }

  # infosys/glue2 block, uses order 36 and 37
  contain 'arc_ce::infosys::glue2'

  # infosys/glue1 block, order 38 and 39
  if $enable_glue1 {
    contain 'arc_ce::infosys::glue1'
  }

  # infosys/cluster block, uses order 40
  contain 'arc_ce::infosys::cluster'

}
