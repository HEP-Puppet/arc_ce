# Class arc_ce::infosys::ldap
# Configures the infosys/ldap block in arc.conf
class arc_ce::infosys::ldap (
  Boolean $enable = false,
  Stdlib::Fqdn $hostname = $arc_ce::config::hostname,
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
  Optional[Arc_ce::LogLevel] $bdii_debug_level = undef,
  Optional[Integer] $bdii_provider_timeout = undef,
  Optional[Stdlib::Unixpath] $bdii_location = undef,
  Optional[Stdlib::Unixpath] $bdii_run_dir = undef,
  Optional[Stdlib::Unixpath] $bdii_log_dir = undef,
  Optional[Stdlib::Unixpath] $bdii_tmp_dir = undef,
  Optional[Stdlib::Unixpath] $bdii_var_dir = undef,
  Optional[Stdlib::Unixpath] $bdii_update_pid_file = undef,
  Optional[String] $bdii_database = undef,
  Optional[Stdlib::Unixpath] $bdii_conf = undef,
  Optional[Stdlib::Unixpath] $bdii_update_cmd = undef,
  Optional[Stdlib::Unixpath] $bdii_db_config = undef,
  Optional[Integer] $bdii_archive_size = undef,
  Optional[Integer] $bdii_breathe_time = undef,
  Optional[Integer] $bdii_delete_delay = undef,
  Optional[Integer] $bdii_read_timeout = undef,
) {
  if $enable {
    Package <| tag == 'arc-package-infosys-ldap' |>
    Service <| tag == 'arc-service-infosys-ldap' |>

    concat::fragment { 'arc.conf_infosys_ldap':
      target  => '/etc/arc.conf',
      content => template("${module_name}/infosys/ldap.erb"),
      order   => 34,
    }
  }
}
