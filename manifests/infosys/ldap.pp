# Class arc_ce::infosys::ldap
# Configures the infosys/ldap block in arc.conf
class arc_ce::infosys::ldap(
  Boolean $enable = false,
  Stdlib::Fqdn $hostname = $::arc_ce::config::hostname,
  Optional[String] $slapd_hostnamebind = undef,
  Stdlib::Port::Unprivileged $port = 2135,
  Optional[String] $user = undef,
  Optional[Stdlib::Unixpath] $slapd = undef,
  Integer $slapd_loglevel = 0,
  Integer $threads = 32,
  Integer $timelimit = 3600,
  Integer $idletimeout = $timelimit + 1,
  Stdlib::Unixpath $infosys_ldap_run_dir = '/var/run/arc/infosys',
  Optional[Stdlib::Unixpath] $ldap_schema_dir = undef,
  Arc_ce::LogLevel $bdii_debug_level = 'WARNING',
  Optional[Integer] $bdii_provider_timeout = undef,
  Stdlib::Unixpath $bdii_location = '/usr',
  Stdlib::Unixpath $bdii_run_dir = '/var/run/arc/bdii',
  Stdlib::Unixpath $bdii_log_dir = '/var/log/arc/bdii',
  Stdlib::Unixpath $bdii_tmp_dir = '/var/tmp/arc/bdii',
  Stdlib::Unixpath $bdii_var_dir = '/var/lib/arc/bdii',
  Stdlib::Unixpath $bdii_update_pid_file = "${bdii_run_dir}/bdii-update.pid",
  String $bdii_database = 'hdb',
  Stdlib::Unixpath $bdii_conf = "${infosys_ldap_run_dir}/bdii.conf",
  Stdlib::Unixpath $bdii_update_cmd = "${bdii_location}/sbin/bdii-update",
  Stdlib::Unixpath $bdii_db_config = '/etc/bdii/DB_CONFIG',
  Integer $bdii_archive_size = 0,
  Integer $bdii_breathe_time = 10,
  Integer $bdii_delete_delay = 0,
  Optional[Integer] $bdii_read_timeout = undef,
) {

  if $enable {

    Package <| tag == 'arc-package-infosys-ldap' |>
    Service <| tag == 'arc-service-bdii' |>

    concat::fragment { 'arc.conf_infosys_ldap':
      target  => '/etc/arc.conf',
      content => template("${module_name}/infosys/ldap.erb"),
      order   => 34,
    }

  }

}
