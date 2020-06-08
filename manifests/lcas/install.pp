# Class arc_ce::lcas::install
# Installs the lcas packages
class arc_ce::lcas::install(
  Optional[String] $ensure = 'present',
  Array[String] $plugin_packages = [
    'lcas-plugins-basic',
    'lcas-plugins-voms',
  ],
) {

  if $ensure !~ Undef {

    @package { 'lcas':
      ensure => 'present',
      tag    => 'arc-packages-lcas',
    }

    @package { $plugin_packages:
      ensure => 'present',
      tag    => 'arc-packages-lcas',
    }

  }

}
