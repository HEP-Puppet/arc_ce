class arc_ce::lrms::condor(
  Stdlib::Absolutepath $condor_bin_path = '/usr/bin',
  Stdlib::Absolutepath $condor_config = '/etc/condor/condor_config',
  Optional[String] $condor_rank = undef,
  Optional[String] $condor_requirements = undef,
) {

  concat::fragment { 'arc.conf_lrms_condor':
    target  => '/etc/arc.conf',
    content => template("${module_name}/lrms/condor.erb"),
    order   => 06,
    require => Concat::Fragment['arc.conf_lrms'],
  }

}
