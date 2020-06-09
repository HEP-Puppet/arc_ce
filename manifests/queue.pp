# Define arc_ce::queue
# Configures the queue block in arc.conf
#
# The default values can be changed by setting arc_ce::queue_defaults::<option> in hiera.
# The default of some of those options can also be set in other parts of the configuration which
# is preferable to setting them as queue_defaults, such as lrms::condor::condor_requirements
define arc_ce::queue (
  Optional[Boolean] $homogeneity = lookup('arc_ce::queue_defaults::homogeneity', Optional[Boolean], undef, undef),
  Optional[String] $comment = lookup('arc_ce::queue_defaults::comment', Optional[String], undef, undef),
  Optional[String] $condor_requirements = lookup('arc_ce::queue_defaults::condor_requirements', Optional[String], undef, undef),
  Optional[Integer] $totalcpus = lookup('arc_ce::queue_defaults::totalcpus', Optional[Integer], undef, undef),
  Optional[String] $nodecpu = lookup('arc_ce::queue_defaults::nodecpu', Optional[String], undef, undef),
  Optional[Integer] $nodememory = lookup('arc_ce::queue_defaults::nodememory', Optional[Integer], undef, undef),
  Optional[Integer] $defaultmemory = lookup('arc_ce::queue_defaults::defaultmemory', Optional[Integer], undef, undef),
  Optional[String] $architecture = lookup('arc_ce::queue_defaults::architecture', Optional[String], undef, undef),
  Array[String] $opsys = lookup('arc_ce::queue_defaults::opsys', Array[String], undef, []),
  Optional[String] $osname = lookup('arc_ce::queue_defaults::osname', Optional[String], undef, undef),
  Optional[String] $osversion = lookup('arc_ce::queue_defaults::osversion', Optional[String], undef, undef),
  Optional[String] $osfamily = lookup('arc_ce::queue_defaults::osfamily', Optional[String], undef, undef),
  String $primary_benchmark = lookup('arc_ce::queue_defaults::primary_benchmark', String, undef, 'HEPSPEC'),
  Hash[String,Numeric] $benchmark = lookup('arc_ce::queue_defaults::benchmark', Hash[String,Numeric], undef, {'HEPSPEC' => 1.0 }),
  Array[Arc_ce::Access] $access = lookup('arc_ce::queue_defaults::access', Array[Arc_ce::Access], undef, []),
  Array[String] $denyaccess = lookup('arc_ce::queue_defaults::denyaccess', Array[String], undef, []),
  Array[String] $allowaccess = lookup('arc_ce::queue_defaults::allowaccess', Array[String], undef, []),
  Array[String] $advertisedvo = lookup('arc_ce::queue_defaults::advertisedvo', Array[String], undef, []),
  Optional[Integer] $maxslotsperjob = lookup('arc_ce::queue_defaults::maxslotsperjob', Optional[Integer], undef, undef),
  Optional[String] $forcedefaultvoms = lookup('arc_ce::queue_defaults::forcedefaultvoms', Optional[String], undef, undef),
  Optional[Arc_ce::Duration] $maxcputime = lookup('arc_ce::queue_defaults::maxcputime', Optional[Arc_ce::Duration], undef, undef),
  Optional[Arc_ce::Duration] $mincputime = lookup('arc_ce::queue_defaults::mincputime', Optional[Arc_ce::Duration], undef, undef),
  Optional[Arc_ce::Duration] $maxwalltime = lookup('arc_ce::queue_defaults::maxwalltime', Optional[Arc_ce::Duration], undef, undef),
  Optional[Arc_ce::Duration] $minwalltime = lookup('arc_ce::queue_defaults::minwalltime', Optional[Arc_ce::Duration], undef, undef),
) {

  unless $primary_benchmark in $benchmark {
    fail("value of primary_benchmark (${primary_benchmark}) not found in benchmark definition of queue ${name}")
  }
  $maxcputime_seconds = arc_ce::duration_to_seconds($maxcputime)
  $mincputime_seconds = arc_ce::duration_to_seconds($mincputime)
  $maxwalltime_seconds = arc_ce::duration_to_seconds($maxwalltime)
  $minwalltime_seconds = arc_ce::duration_to_seconds($minwalltime)

  concat::fragment { "arc.conf_queue_${name}":
    target  => '/etc/arc.conf',
    content => template("${module_name}/queue.erb"),
    order   => 41,
  }

}
