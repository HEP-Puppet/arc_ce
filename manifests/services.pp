class arc_ce::services(
  Stdlib::Ensure::Service $arex_ensure = 'running',
  Boolean $arex_enable = true,
  Stdlib::Ensure::Service $gridftpd_ensure = 'running',
  Boolean $gridftpd_enable = true,
  Stdlib::Ensure::Service $bdii_ensure = 'running',
  Boolean $bdii_enable = true,
) {

  service { 'arc-arex':
    ensure     => $arex_ensure,
    enable     => $arex_enable,
    hasrestart => true,
    hasstatus  => true,
  }

  # the following virtual services are realized when the corresponding blocks in arc.conf are enabled and configured

  @service { 'arc-service-gridftpd':
    name       => 'arc-gridftpd',
    ensure     => $gridftpd_ensure,
    enable     => $gridftpd_enable,
    hasrestart => true,
    hasstatus  => true,
    subscribe  => Concat['/etc/arc.conf'],
  }

  @service { 'arc-service-bdii':
    name       => 'bdii',
    ensure     => $bdii_ensure,
    enable     => $bdii_enable,
    hasrestart => true,
    hasstatus  => true,
    subscribe  => Concat['/etc/arc.conf'],
  }

}
