# Class arc_ce::install
# Installs the ARC6 package
class arc_ce::install(
  Enum['epel', 'nordugrid'] $install_from = 'epel',
  String $ensure = 'present',
  Optional[String] $gridftpd_ensure = 'present',
  Optional[String] $infosysldap_ensure = 'present',
) {
  case $install_from {
    'epel': {
      $arex_package = 'nordugrid-arc6-arex'
      $gridftpd_package = 'nordugrid-arc6-gridftpd'
      $infosysldap_package = 'nordugrid-arc6-infosys-ldap'
    }
    'nordugrid': {
      $arex_package = 'nordugrid-arc-arex'
      $gridftpd_package = 'nordugrid-arc-gridftpd'
      $infosysldap_package = 'nordugrid-arc-infosys-ldap'
    }
    default: {}
  }

  package { $arex_package:
    ensure  => $ensure,
  }

  # define virtual resources for non-essential packages
  # they are realized when the related block in arc.conf is enabled

  if  $gridftpd_ensure !~ Undef {
    @package { 'arc-package-gridftpd':
      name   => $gridftpd_package,
      ensure => $gridftpd_ensure,
    }
  }

  if $infosysldap_ensure !~ Undef {
    @package { 'arc-package-infosys-ldap':
      name   => $infosysldap_package,
      ensure => $infosysldap_ensure,
    }
  }

  include arc_ce::lcmaps::install
  include arc_ce::lcas::install

}
