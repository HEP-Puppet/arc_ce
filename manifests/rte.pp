# Define arc_ce::rte
# Manages a single runtime environment (RTE)
define arc_ce::rte(
  Boolean $enable = false,
  Optional[Stdlib::Filesource] $source = undef,
  Optional[String] $content = undef,
) {

  if $content =~ Undef and $source =~ Undef {
    fail("only one of content and source are allowed to be defined in rte ${title}")
  }

  file { "/etc/arc/runtime/${name}":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => $content,
    source  => $source,
  }

  file { "/var/spool/arc/jobstatus/rte/enabled/${name}":
    ensure => ($enable ? {
      true    => 'link',
      default => 'absent',
    }),
    target => "/etc/arc/runtime/${name}",
  }

}
