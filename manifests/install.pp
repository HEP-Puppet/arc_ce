# Class arc_ce::install
# Installs the ARC6 package
class arc_ce::install(
  Enum['epel', 'nordugrid'] $install_from = 'epel',
) {
  case $install_from {
    'epel': {
      $arex_package = 'nordugrid-arc6-arex'
    }
    'nordugrid': {
      $arex_package = 'nordugrid-arc-arex'
    }
    default: {}
  }

  package { $arex_package:
    ensure  => 'present',
  }

#  include arc_ce::lcmaps::install
#  include arc_ce::lcas::install
}
