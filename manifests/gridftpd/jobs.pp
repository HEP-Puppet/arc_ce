# Class arc_ce::gridftpd::jobs
# Configures the gridftp/jobs block in arc.conf
class arc_ce::gridftpd::jobs(
  Boolean $enable = false,
  Boolean $allownew = true,
  Array[String] $allownew_override = [],
  Array[String] $allowaccess = [],
  Array[String] $denyaccess = [],
  Integer $maxjobdesc = 5242880,
) {

  if $enable {
    concat::fragment { 'arc.conf_gridftpd_jobs':
      target  => '/etc/arc.conf',
      content => template("${module_name}/gridftpd/jobs.erb"),
      order   => 31,
    }
  }

}
