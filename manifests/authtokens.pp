# @summary Enables the authtokens block in arc.conf
class arc_ce::authtokens (
  Boolean $enable = false,
) {
  if $enable {
    concat::fragment { "arc.conf_authtokens":
      target  => '/etc/arc.conf',
      content => "[authtokens]\n\n",
      order   => 11,
    }
  }
}
