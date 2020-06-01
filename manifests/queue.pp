# Define arc_ce::queue
# Configures the queue block in arc.conf
define arc_ce::queue (
  Optional[Boolean] $homogeneity = undef,
  Optional[String] $comment = undef,
  Optional[String] $condor_requirements = undef,
  Optional[Integer] $totalcpus = undef,
  Optional[String] $nodecpu = undef,
  Optional[Integer] $nodememory = undef,
  Optional[Integer] $defaultmemory = undef,
  Optional[String] $architecture = undef,
  Array[String] $opsys = [],
  Optional[String] $osname = undef,
  Optional[String] $osversion = undef,
  Optional[String] $osfamily = undef,
  String $primary_benchmark = 'HEPSPEC',
  Hash[String,Numeric] $benchmark = {'HEPSPEC' => 1.0 },
  Array[Arc_ce::Access] $access = [],
  Array[String] $denyaccess = [],
  Array[String] $allowaccess = [],
  Array[String] $advertisedvo = [],
  Optional[Integer] $maxslotsperjob = undef,
  Optional[String] $forcedefaultvoms = undef,
  Optional[Integer] $maxcputime = undef,
  Optional[Integer] $mincputime = undef,
  Optional[Integer] $maxwalltime = undef,
  Optional[Integer] $minwalltime = undef,
) {

  unless $primary_benchmark in $benchmark {
    fail("value of primary_benchmark (${primary_benchmark}) not found in benchmark definition of queue ${name}")
  }
  concat::fragment { "arc.conf_queue_${name}":
    target  => '/etc/arc.conf',
    content => template("${module_name}/queue.erb"),
    order   => 41,
  }

}
