define arc_ce::queue (
  $benchmark_results       = [
    'SPECINT2000 222',
    'SPECFP2000 333',
    'HEPSPEC2006 444'],
  $queue_name              = $title,
  $homogeneity             = 'True',
  $comment                 = 'Default queue',
  $default_memory          = '2048',
  $node_memory             = '2048',
  $main_memory_size        = '32768',
  $time_limit              = '1800',
  $os_family               = 'linux',
  $cluster_description     = {
    'OSFamily'      => 'linux',
    'OSName'        => 'ScientificSL',
    'OSVersion'     => '6.4',
    'OSVersionName' => 'Carbon',
    'CPUVendor'     => 'AMD',
    'CPUClockSpeed' => '3100',
    'CPUModel'      => 'AMD Opteron(tm) Processor 4386',
    'totalcpu'      => '42',
  }
  ,
  $condor_requirements     = '(Opsys == "linux") && (OpSysAndVer == "SL6")',
  $cluster_cpudistribution = ['16cpu:12'],) {
  concat::fragment { "arc_cfg_queue_${title}":
    target  => '/etc/arc.conf',
    order   => 10,
    content => template("${module_name}/queue.erb")
  }
}
