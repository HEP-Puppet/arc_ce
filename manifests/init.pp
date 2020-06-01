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

  contain 'arc_ce::install'
  contain 'arc_ce::config'
  contain 'arc_ce::services'

}
