class arc_ce::runtime_env {
  file { '/etc/arc/runtime/ENV/GLITE':
    ensure  => present,
    source  => "puppet:///modules/${module_name}/RTEs/GLITE",
    require => File['/etc/arc/runtime/ENV'],
  }

  file { '/etc/arc/runtime/ENV/PROXY':
    ensure  => present,
    source  => "puppet:///modules/${module_name}/RTEs/PROXY",
    require => File['/etc/arc/runtime/ENV'],
  }
}
