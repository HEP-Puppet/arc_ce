# Class arc_ce::runtime_env
# Manages runtime environments (RTEs)
class arc_ce::runtime_env(
  Boolean $add_atlas = true,
  Boolean $add_glite = true,
  Boolean $purge_enabled_dir = true,
  Array[String] $enable = [ 'ENV/PROXY' ],
  Hash[String,Hash] $additional_rtes = {},
) {

  # create directories for custom runtime environments
  $user_rte_dirs = unique(unique($additional_rtes.keys() +
    ($add_atlas ? {
      true    => ['APPS/HEP/ATLAS-SITE-LCG'],
      default => [],
    }) +
    ($add_glite ? {
      true    => ['ENV/GLITE'],
      default => [],
    })
  ).map |$x| { split(dirname($x), '/').reduce([]) |$m, $x| { $m + join([$m[-1], $x], '/')}}.flatten())

  file { [ '/etc/arc/', '/etc/arc/runtime/' ] + $user_rte_dirs.map |$x| { "/etc/arc/runtime${x}" }:
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  # create directories for enabled runtime environments
  $enabled_rte_dirs =
    unique(unique($enable).map |$x| { split(dirname($x), '/').reduce([]) |$m, $x| { $m + join([$m[-1], $x], '/')}}.flatten())

  file { ['/var/spool/arc/jobstatus/rte/enabled'] + $enabled_rte_dirs.map |$x| { "/var/spool/arc/jobstatus/rte/enabled${x}" }:
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    purge   => $purge_enabled_dir,
    recurse => true,
    force   => true,
  }

  # add atlas RTE
  if $add_atlas {
    # create empty ATLAS-SITE-LCG for ATLAS prd jobs
    arc_ce::rte { 'APPS/HEP/ATLAS-SITE-LCG':
      enable  => 'APPS/HEP/ATLAS-SITE-LCG' in $enable,
      source  => "puppet:///modules/${module_name}/RTEs/ATLAS-SITE-LCG",
      require => File['/etc/arc/runtime/APPS/HEP'],
    }
  }

  # add glite RTE
  if $add_glite {
    # add glite env
    arc_ce::rte { 'ENV/GLITE':
      enable  => 'ENV/GLITE' in $enable,
      source  => "puppet:///modules/${module_name}/RTEs/GLITE",
      require => File['/etc/arc/runtime/ENV'],
    }
  }

  # add user defined RTEs
  $additional_rtes.each |String $rte, Hash $rte_cfg| {
    $rte_path = dirname($rte)
    arc_ce::rte { $rte:
      enable  => $rte in $enable,
      source  => 'source' in $rte_cfg ? {
        true    => $rte_cfg['source'],
        default => undef,
      },
      content => 'content' in $rte_cfg ? {
        true    => $rte_cfg['content'],
        default => undef,
      },
      require => File["/etc/arc/runtime/${rte_path}"],
    }
  }

  # enable default RTEs
  [ 'ENV/CANDYPOND', 'ENV/CONDOR/DOCKER', 'ENV/LRMS-SCRATCH', 'ENV/PROXY', 'ENV/RTE', 'ENV/SINGULARITY' ].each |String $rte| {
    $rte_path = dirname($rte)
    if $rte in $enable {
      file { "/var/spool/arc/jobstatus/rte/enabled/${rte}":
        ensure  => 'link',
        target  => "/usr/share/arc/rte/${rte}",
        require => File["/var/spool/arc/jobstatus/rte/enabled/${rte_path}"],
      }
    } else {
      file { "/var/spool/arc/jobstatus/rte/enabled/${rte}":
        ensure  => 'absent',
      }
    }
  }

}
