# Class arc_ce::arex
# Configures the a-rex blocks in arc.conf
#
# Notes
# had to call the loglevel arexloglevel because puppet appears to ignore the datatype definition and
# uses its own definition if the variable is called loglevel, needs further investigation
class arc_ce::arex(
  String $user = 'root',
  String $group = 'root',
  Boolean $norootpower = false,
  Arc_ce::DelegationDb $delegationdb = 'sqlite',
  Boolean $watchdog = false,
  Arc_ce::LogLevel $arexloglevel = 'INFO',
  Stdlib::Unixpath $logfile = '/var/log/arc/arex.log',
  Stdlib::Unixpath $joblog = '/var/log/arc/arex-jobs.log',
  Arc_ce::FixDirectories $fixdirectories = 'yes',
  Stdlib::Unixpath $controldir = '/var/spool/arc/jobstatus',
  Hash[Arc_ce::SessionDir, Optional[Boolean]] $sessiondir = {'/var/spool/arc/sessiondir' => false,},
  Integer $defaultttl = 604800,
  Integer $defaultttr = 2592000,
  Boolean $shared_filesystem = true,
  Optional[Stdlib::Unixpath] $scratchdir = undef,
  Optional[Stdlib::Unixpath] $shared_scratch = undef,
  Stdlib::Unixpath $tmpdir = '/tmp',
  Array[Stdlib::Unixpath] $runtimedir = [ '/etc/arc/runtime' ],
  Array[Integer,5,5] $maxjobs = [-1, -1, -1, -1, -1],
  Integer $maxrerun = 5,
  Array[Arc_ce::StateCallout] $statecallout = [],
  Integer $wakeupperiod = 180,
  Integer $infoproviders_timelimit = 10800,
  Stdlib::Unixpath $pidfile = '/var/run/arched-arex.pid',
  Optional[Stdlib::Unixpath] $helper = undef,
  Stdlib::Unixpath $helperlog = '/var/log/arc/job.helper.errors',
  Optional[String] $forcedefaultvoms = undef,
) {

  # arex block
  concat::fragment { 'arc.conf_arex':
    target  => '/etc/arc.conf',
    content => template("${module_name}/arex/common.erb"),
    order   => 17,
  }

  # arex/cache block (and sub-blocks), reserved order 18
  # contain 'arc_ce::arex::cache'

  # arex/data-staging block, uses order 19
  contain 'arc_ce::arex::datastaging'

  # arex/ws block and sub-blocks, reserved order 20 - 24
  # contain 'arc_ce::arex::ws'

  # arex/jura block, uses order 25
  contain 'arc_ce::arex::jura'

  $sessiondir.keys.each |Stdlib::Unixpath $sd| {
    file { $sd:
      ensure => 'directory',
      owner  => $user,
      group  => $user,
      mode   => '0755',
    }
  }

  file { $controldir:
    ensure => 'directory',
    owner  => $user,
    group  => $user,
    mode   => '0755',
  }

}
