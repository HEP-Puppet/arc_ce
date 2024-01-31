# Class arc_ce::lrms::condor
# Configures the condor options in arc.conf if the lrms is set to condor
class arc_ce::lrms::condor (
  Stdlib::Unixpath $condor_bin_path = '/usr/bin',
  Stdlib::Unixpath $condor_config = '/etc/condor/condor_config',
  Optional[String] $condor_rank = undef,
  Optional[String] $condor_requirements = undef,
) {
  concat::fragment { 'arc.conf_lrms_condor':
    target  => '/etc/arc.conf',
    content => template("${module_name}/lrms/condor.erb"),
    order   => 15,
    require => Concat::Fragment['arc.conf_lrms'],
  }
}
