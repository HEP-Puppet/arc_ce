# Class arc_ce::lcmaps::install
# Installs the lcmaps packages
class arc_ce::lcmaps::install(
  Optional[String] $ensure = 'present',
  Array[String] $plugin_packages = [
    'lcmaps-plugins-c-pep',
    'lcmaps-plugins-verify-proxy',
  ],
) {

  if $ensure !~ Undef {

    @package { ['nordugrid-arc6-plugins-lcas-lcmaps', 'lcmaps' ]:
      ensure => $ensure,
      tag    => 'arc-packages-lcmaps',
    }

    @package { $plugin_packages:
      ensure => 'present',
      tag    => 'arc-packages-lcmaps',
    }
  }

  # 'lcmaps-plugins-basic',
  # 'lcmaps-plugins-voms',
}
