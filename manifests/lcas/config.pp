class arc_ce::lcas::config {
  file { '/etc/lcas/lcas.db':
    ensure => present,
    source => "puppet:///modules/${module_name}/lcas.db",
    require => Package[lcas],
  }

  file { '/etc/lcas/ban_users.db':
    ensure => present,
    source => "puppet:///modules/${module_name}/ban_users.db",
    require => Package[lcas],
  }
}
