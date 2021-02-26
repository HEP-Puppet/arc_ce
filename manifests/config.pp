# Class: arc_ce::config
# Sets up the configuration file
class arc_ce::config(
  # common block options
  Stdlib::Fqdn $hostname = $facts['networking']['fqdn'],
  Stdlib::Unixpath $x509_host_cert = '/etc/grid-security/hostcert.pem',
  Stdlib::Unixpath $x509_host_key = '/etc/grid-security/hostkey.pem',
  Stdlib::Unixpath $x509_cert_dir = '/etc/grid-security/certificates',
  Stdlib::Unixpath $x509_voms_dir = '/etc/grid-security/vomsdir',
  Arc_ce::Vomsprocessing $voms_processing = 'standard',
  # authgroup block definitions
  Hash[String, Hash] $authgroups = {},
  Optional[String] $all_authgroup = undef,
  Integer $all_authgroup_order = 999,
  # mapping block definitions
  Array[Arc_ce::MappingRule] $mapping_rules = [],
  # queue block definitions
  Hash[String, Hash] $queues = {},
  # default values for classes that use the same options
  Array[Stdlib::Port::Unprivileged,2,2] $globus_tcp_port_range = [9000, 9300],
  Array[Stdlib::Port::Unprivileged,2,2] $globus_udp_port_range = [9000, 9300],
) {

  concat { '/etc/arc.conf':
    order   => 'alpha',
    require => Package['nordugrid-arc-arex'],
  }

  # common block
  concat::fragment { 'arc.conf_common':
    target  => '/etc/arc.conf',
    content => template("${module_name}/common.erb"),
    order   => 10,
  }

  # authgroup blocks, uses order 11
  create_resources('arc_ce::authgroup', $authgroups)

  # add an authgroup that covers all other configured authgroups
  if $all_authgroup !~ Undef {
    arc_ce::authgroup { $all_authgroup:
      order => $all_authgroup_order,
      rules => [(['authgroup ='] + $authgroups.keys()).join(' ')],
    }
  }

  # mapping block
  concat::fragment { 'arc.conf_mapping':
    target  => '/etc/arc.conf',
    content => template("${module_name}/mapping.erb"),
    order   => 12,
  }

  $mapping_rules.each |Arc_ce::MappingRule $mr| {
    if $mr =~ /^map_with_plugin\s*=.* \/usr\/libexec\/arc\/arc-lcmaps / {
      Package <| tag == 'arc-packages-lcmaps' |>
      contain 'arc_ce::lcmaps::config'
    }
  }

  # 13 reserverd for authtokens

  # lrms block, uses order 14 (common options) and 15 (reserved for lrms specific options) and 16 (reserved for lrms/ssh block)
  contain 'arc_ce::lrms'

  # arex block, uses order 17 to 28, leaving 29 as reserved
  contain 'arc_ce::arex'

  # gridftpd block, uses order 30 to 32
  contain 'arc_ce::gridftpd'

  # infosys block, uses order 33 to 40
  contain 'arc_ce::infosys'

  # queue blocks, uses order 41
  create_resources('arc_ce::queue', $queues)

  if false {

    # set up runtime environments
    class {'arc_ce::runtime_env':}

    # apply manual fixes
    # for details check fixes.md
    $apply_fixes = false
    if $apply_fixes {
      file { '/usr/share/arc/submit-condor-job':
        source => "puppet:///modules/${module_name}/fixes/submit-condor-job.ARC.${apply_fixes}",
        backup => true,
      }

      file { '/usr/share/arc/Condor.pm':
        source => "puppet:///modules/${module_name}/fixes/Condor.pm.ARC.${apply_fixes}",
        backup => true,
      }

      file { '/usr/share/arc/glue-generator.pl':
        source => "puppet:///modules/${module_name}/fixes/glue-generator.pl.ARC.${apply_fixes}",
        backup => true,
        mode   => '0755',
        notify => Exec['create-bdii-config'],
      }
      exec {'create-bdii-config':
        command     => '/usr/share/arc/create-bdii-config',
        refreshonly => true,
      }
    }
  }

}
