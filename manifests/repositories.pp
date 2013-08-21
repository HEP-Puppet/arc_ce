class arc_ce::repositories (
  $nordugrid_repo_version = '13.02',
  $use_nordugrid          = false,
  $use_emi                = false,
  $emi_repo_version       = 3) {
  if !$use_emi and !$use_nordugrid {
    notify { 'No repository for ARC CE defined': }
  }

  if $use_nordugrid {
    yumrepo { 'nordugrid':
      descr    => 'NorduGrid - \$basearch - base',
      baseurl  => "http://download.nordugrid.org/repos/${nordugrid_repo_version}/centos/\$releasever/\$basearch/base",
      enabled  => 1,
      gpgcheck => 1,
      gpgkey   => 'http://download.nordugrid.org/RPM-GPG-KEY-nordugrid',
    }

    yumrepo { 'nordugrid-updates':
      descr    => 'NorduGrid - \$basearch - updates',
      baseurl  => "http://download.nordugrid.org/repos/${nordugrid_repo_version}/centos/\$releasever/\$basearch/updates",
      enabled  => 1,
      gpgcheck => 1,
      gpgkey   => 'http://download.nordugrid.org/RPM-GPG-KEY-nordugrid',
    }

    yumrepo { 'nordugrid-testing':
      descr    => 'NorduGrid - \$basearch - testing',
      baseurl  => "http://download.nordugrid.org/repos/${nordugrid_repo_version}/centos/\$releasever/\$basearch/testing",
      enabled  => 1,
      gpgcheck => 1,
      gpgkey   => 'http://download.nordugrid.org/RPM-GPG-KEY-nordugrid',
    }
  }

  if $use_emi {
    yumrepo { "emi${emi_repo_version}-base":
      descr    => 'EMI - \$basearch - base',
      baseurl  => "http://emisoft.web.cern.ch/emisoft/dist/EMI/${emi_repo_version}/sl6/\$basearch/base",
      enabled  => 1,
      gpgcheck => 1,
      gpgkey   => "http://emisoft.web.cern.ch/emisoft/dist/EMI/${emi_repo_version}/RPM-GPG-KEY-emi"
    }

    yumrepo { "emi${emi_repo_version}-updates":
      descr    => 'EMI - \$basearch - updates',
      baseurl  => "http://emisoft.web.cern.ch/emisoft/dist/EMI/${emi_repo_version}/sl6/\$basearch/updates",
      enabled  => 1,
      gpgcheck => 1,
      gpgkey   => "http://emisoft.web.cern.ch/emisoft/dist/EMI/${emi_repo_version}/RPM-GPG-KEY-emi"
    }
  }

  yumrepo { 'EGI-trustanchors':
    descr    => 'EGI-trustanchors',
    baseurl  => 'http://repository.egi.eu/sw/production/cas/1/current/',
    gpgcheck => 1,
    gpgkey   => 'http://repository.egi.eu/sw/production/cas/1/GPG-KEY-EUGridPMA-RPM-3',
    enabled  => 1,
    priority => 80,
  }

}