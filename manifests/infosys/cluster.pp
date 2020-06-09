# Class arc_ce::infosys::cluster
# Configures the infosys/cluster block in arc.conf
class arc_ce::infosys::cluster(
  Optional[String] $cluster_alias = undef,
  Stdlib::Fqdn $hostname = $::arc_ce::config::hostname,
  Optional[String] $interactive_contactstring = undef,
  Optional[String] $comment = undef,
  Optional[String] $cluster_location = undef,
  Array[String] $cluster_owner = [],
  Array[String] $advertisedvo = [],
  Array[String] $clustersupport = [],
  Boolean $homogeneity = true,
  String $architecture = 'adotf',
  Array[String] $opsys = [],
  String $nodecpu = 'adotf',
  Optional[Integer] $nodememory = undef,
  Array[String] $middleware = [],
  Array[Arc_ce::NodeAccess,0,2] $nodeaccess = [],
  Array[String] $localse = [],
  Array[Arc_ce::CpuDistribution] $cpudistribution = [],
  Optional[Arc_ce::Duration] $maxcputime = undef,
  Optional[Arc_ce::Duration] $mincputime = undef,
  Optional[Arc_ce::Duration] $maxwalltime = undef,
  Optional[Arc_ce::Duration] $minwalltime = undef,
) {

  $maxcputime_seconds = arc_ce::duration_to_seconds($maxcputime)
  $mincputime_seconds = arc_ce::duration_to_seconds($mincputime)
  $maxwalltime_seconds = arc_ce::duration_to_seconds($maxwalltime)
  $minwalltime_seconds = arc_ce::duration_to_seconds($minwalltime)

  concat::fragment { 'arc.conf_infosys_cluster':
    target  => '/etc/arc.conf',
    content => template("${module_name}/infosys/cluster.erb"),
    order   => 40,
  }

}
