# Class: arc_ce
#
# This module manages arc_ce
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class arc_ce {
  class { 'arc_ce::repositories': }

  class { 'arc_ce::install': require => Class['arc_ce::repositories'] }

  class { 'arc_ce::config': require => Class['arc_ce::install'] }

  class { 'arc_ce::services': require => Class['arc_ce::config'] }
}
