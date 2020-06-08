# Class arc_ce::services
# Manages the ARC services
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
    subscribe  => Concat['/etc/arc.conf'],
  }

  # the following virtual services are realized when the corresponding blocks in arc.conf are enabled and configured

  @service { 'arc-service-gridftpd':
    ensure     => $gridftpd_ensure,
    name       => 'arc-gridftpd',
    enable     => $gridftpd_enable,
    hasrestart => true,
    hasstatus  => true,
    subscribe  => Concat['/etc/arc.conf'],
  }

  @service { 'arc-service-infosys-ldap':
    ensure     => $bdii_ensure,
    name       => 'arc-infosys-ldap',
    enable     => $bdii_enable,
    hasrestart => true,
    hasstatus  => true,
    require    => Service['arc-arex'],
  }

  @service { 'arc-service-infosys-ldap-slapd':
    ensure     => $bdii_ensure,
    name       => 'arc-infosys-ldap-slapd',
    enable     => $bdii_enable,
    hasrestart => true,
    hasstatus  => true,
    require    => Service['arc-service-infosys-ldap'],
    tag        => 'arc-service-infosys-ldap',
  }

}
