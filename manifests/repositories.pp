class arc_ce::repositories (
  $nordugrid_repo_version = $arc_ce::params::nordugrid_repo_version,
  $use_nordugrid          = $arc_ce::params::use_nordugrid_repo,
  $use_emi                = $arc_ce::params::use_emi_repo,
  $emi_repo_version       = $arc_ce::params::emi_repo_version) inherits arc_ce::params {
  if !$use_emi and !$use_nordugrid {
    notify { "No repository for ARC CE defined": }
  }

  if $use_nordugrid {
    yumrepo { 'nordugrid':
      name     => "NorduGrid - \$basearch - base",
      baseurl  => "http://download.nordugrid.org/repos/${nordugrid_repo_version}/centos/\$releasever/\$basearch/base",
      enabled  => true,
      gpgcheck => true,
      gpgkey   => "http://download.nordugrid.org/RPM-GPG-KEY-nordugrid",
    }

    yumrepo { 'nordugrid-updates':
      name     => "NorduGrid - \$basearch - updates",
      baseurl  => "http://download.nordugrid.org/repos/${nordugrid_repo_version}/centos/\$releasever/\$basearch/updates",
      enabled  => true,
      gpgcheck => true,
      gpgkey   => "http://download.nordugrid.org/RPM-GPG-KEY-nordugrid",
    }

    yumrepo { 'nordugrid-testing':
      name     => "NorduGrid - \$basearch - testing",
      baseurl  => "http://download.nordugrid.org/repos/${nordugrid_repo_version}/centos/\$releasever/\$basearch/testing",
      enabled  => true,
      gpgcheck => true,
      gpgkey   => "http://download.nordugrid.org/RPM-GPG-KEY-nordugrid",
    }
  }

  if $use_emi {
    yumrepo { 'EMI':
      name     => "EMI - \$basearch - base",
      baseurl  => "http://emisoft.web.cern.ch/emisoft/dist/EMI/${emi_repo_version}/sl6/\$basearch/base/repoview",
      enabled  => true,
      gpgcheck => true,
      gpgkey   => "http://emisoft.web.cern.ch/emisoft/dist/EMI/${emi_repo_version}/RPM-GPG-KEY-emi"
    }

    yumrepo { 'EMI-updates':
      name     => "EMI - \$basearch - updates",
      baseurl  => "http://emisoft.web.cern.ch/emisoft/dist/EMI/${emi_repo_version}/sl6/\$basearch/updates/repoview",
      enabled  => true,
      gpgcheck => true,
      gpgkey   => "http://emisoft.web.cern.ch/emisoft/dist/EMI/${emi_repo_version}/RPM-GPG-KEY-emi"
    }
  }

}