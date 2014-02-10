class arc_ce::firewall ($globus_port_range = [50000, 52000]) {
  firewall { '200 For the web service interface':
    action => accept,
    proto  => tcp,
    state  => NEW,
    port   => [80, 443],
  }

  firewall { '201 For the bdii service interface':
    action => accept,
    proto  => tcp,
    state  => NEW,
    port   => 2170,
  }

  firewall { '202 For HTTPg':
    action => accept,
    proto  => tcp,
    state  => NEW,
    port   => 8443,
  }

  firewall { '203 For the GridFTP service interface':
    action => accept,
    proto  => tcp,
    state  => NEW,
    port   => [2811, 2119],
  }

  firewall { '204 For GridFTP data channels':
    action => accept,
    proto  => [tcp, udp],
    state  => NEW,
    dport  => join($globus_port_range, '-'),
  }

  firewall { '205 For the LDAP service interface':
    action => accept,
    proto  => tcp,
    port   => 2135,
  }
}
