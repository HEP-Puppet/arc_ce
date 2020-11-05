# Class arc_ce::lrms
# Configures the common options in the lrms block in arc.conf
class arc_ce::lrms(
  Arc_ce::Lrms $lrms = 'fork',
  Optional[String] $defaultqueue = undef,
  Optional[String] $lrmsconfig = undef,
  Hash[String,Numeric,0,1] $benchmark = {},
  Optional[Integer] $defaultmemory = undef,
  Optional[Stdlib::Fqdn] $nodename = undef,
  Stdlib::Unixpath $gnu_time = '/usr/bin/time',
) {

  concat::fragment { 'arc.conf_lrms':
    target  => '/etc/arc.conf',
    content => template("${module_name}/lrms/common.erb"),
    order   => 14,
  }

  contain "arc_ce::lrms::${lrms}"
}
