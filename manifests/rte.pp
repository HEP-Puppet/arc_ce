# Define arc_ce::rte
# Manages a single runtime environment (RTE)
define arc_ce::rte(
  Boolean $enable = false,
  Boolean $default = false,
  Boolean $dummy = false,
  Optional[Stdlib::Filesource] $source = undef,
  Optional[String] $content = undef,
) {

  $rte_path = dirname($name)

  if $content !~ Undef and $source !~ Undef {
    fail("only one of content and source is allowed to be defined for rte ${title}")
  } elsif $content =~ Undef and $source =~ Undef {
    # if neither source nor content is defined then it should be a system or dummy RTE and we create only the links
    $sourcefile = $dummy ? {
      true    => '/dev/null',
      default => "/usr/share/arc/rte/${name}",
    }
    $require = [
      Package['nordugrid-arc-arex'],
    ]
  } else {
    $sourcedir = '/etc/arc/runtime'
    $sourcefile = "${sourcedir}/${name}"
    $require = [
      File["${sourcedir}/${rte_path}"],
    ]
    file { $sourcefile:
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => $content,
      source  => $source,
      require => File["${sourcedir}/${rte_path}"],
    }
  }

  file { "/var/spool/arc/jobstatus/rte/enabled/${name}":
    ensure  => ($enable ? {
      true    => 'link',
      default => 'absent',
    }),
    target  => $sourcefile,
    require => ($enable ? {
      true    => [File["/var/spool/arc/jobstatus/rte/enabled/${rte_path}"]] + $require,
      default => undef,
    }),
  }

  file { "/var/spool/arc/jobstatus/rte/default/${name}":
    ensure  => (($default and $enable) ? {
      true    => 'link',
      default => 'absent',
    }),
    target  => $sourcefile,
    require => (($default and $enable) ? {
      true    => [File["/var/spool/arc/jobstatus/rte/default/${rte_path}"]] + $require,
      default => undef,
    }),
  }

}
