define arc_ce::queue (
  $queue_name          = $title,
  $homogeneity         = 'True',
  $comment             = 'Default queue',
  $default_memory      = '2048',
  $node_memory         = '2048',
  $main_memory_size    = 32768,
  $time_limit          = '1800',
  $os_family           = 'linux',
  $opsys               = [
    'ScientificSL',
    '6.4',
    'Carbon'],
  $nodecpu             = 'AMD Opteron(tm) Processor 4386 @ 3.1GHz',
  $condor_requirements = '(Opsys == \'linux\') && (OpSysAndVer == \'SL6\')') {
  concat::fragment { "arc_cfg_queue_${title}":
    target  => '/etc/arc.conf',
    order   => 10,
    content => template("${module_name}/queue.erb")
  }
}