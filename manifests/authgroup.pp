# Define: arc_ce::authgroup
# Configures the authgroup blocks in arc.conf
define arc_ce::authgroup (
  Array[Arc_ce::AuthgroupRule] $rules = [],
  Integer $order = 1,
) {
  concat::fragment { "arc.conf_authgroup_${name}":
    target  => '/etc/arc.conf',
    content => template("${module_name}/authgroup.erb"),
    order   => "12-${order}",
  }

  $rules.each |Arc_ce::AuthgroupRule $agr| {
    if $agr =~ /^plugin\s*=.* \/usr\/libexec\/arc\/arc-lcas / {
      Package <| tag == 'arc-packages-lcas' |>
      include 'arc_ce::lcas::config'
    }
  }
}
