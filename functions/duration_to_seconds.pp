function arc_ce::duration_to_seconds(Optional[Arc_ce::Duration] $duration) >> Optional[Integer] {
  if $duration =~ Undef {
    $seconds = undef
  } elsif $duration =~ Integer {
    $seconds = $duration
  } else {
    $d = $duration[-1]
    case $d {
      'd': { $mult = 86400 }
      'h': { $mult = 3600 }
      'm': { $mult = 60 }
      default: { fail("unsupported duration ${duration}") }
    }
    $seconds = Integer($duration[0,-2]) * $mult
  }
  $seconds
}
