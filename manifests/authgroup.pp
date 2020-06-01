# Define: arc_ce::authgroup
# Configures the authgroup blocks in arc.conf
define arc_ce::authgroup(
  Array[Arc_ce::AuthgroupRule] $rules = [],
) {

  concat::fragment { "arc.conf_authgroup_${name}":
    target  => '/etc/arc.conf',
    content => template("${module_name}/authgroup.erb"),
    order   => 11,
  }

  $rules.each |Arc_ce::AuthgroupRule $agr| {
    if $agr =~ /^plugin\s*=.* \/usr\/libexec\/arc\/arc-lcas / {
       Package <| tag == 'arc-packages-lcas' |>
       include 'arc_ce::lcas::config'
    }
  }
}
