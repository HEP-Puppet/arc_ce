class arc_ce::services {
  service { "gridftpd":
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }

  service { "a-rex":
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }

  service { "nordugrid-arc-slapd":
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }

  service { "nordugrid-arc-bdii":
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }

  service { "nordugrid-arc-inforeg":
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }
  
  # the services should start in a certain order
  Service['gridftpd'] -> Service['a-rex'] -> Service['nordugrid-arc-slapd']  -> Service['nordugrid-arc-bdii']  -> Service['nordugrid-arc-inforeg'] 
}