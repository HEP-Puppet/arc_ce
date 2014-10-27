class arc_ce::runtime_env {
  # create directories
  # create folders for runtime environments
  file { [
    '/etc/arc/',
    '/etc/arc/runtime/',
    '/etc/arc/runtime/ENV']:
    ensure => directory,
  }

  # Create empty ATLAS-SITE-LCG  for ATLAS prd jobs
  file { ['/etc/arc/runtime/APPS', '/etc/arc/runtime/APPS/HEP',]:
    ensure  => directory,
    require => File['/etc/arc/runtime'],
  }

  file { '/etc/arc/runtime/APPS/HEP/ATLAS-SITE-LCG':
    ensure  => present,
    source  => "puppet:///modules/${module_name}/RTEs/ATLAS-SITE-LCG",
    require => File['/etc/arc/runtime/APPS/HEP'],
    mode    => '0755',
  }

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
