class arc_ce::lrms(
  Arc_ce::Lrms $lrms = 'fork',
  Optional[String] $defaultqueue = undef,
  Optional[String] $lrmsconfig = undef,
  Optional[Integer] $defaultmemory = undef,
  Optional[Stdlib::Fqdn] $nodename = undef,
  Stdlib::Absolutepath $gnu_time = '/usr/bin/time',
) {

  concat::fragment { 'arc.conf_lrms':
    target  => '/etc/arc.conf',
    content => template("${module_name}/lrms/common.erb"),
    order   => 05,
  }

  contain "arc_ce::lrms::${lrms}"
}
