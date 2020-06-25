type Arc_ce::StateCallout = Struct[{
  state     => Arc_ce::JobState,
  timeout   => Optional[Integer],
  onsuccess => Optional[Arc_ce::OnAction],
  onfailure => Optional[Arc_ce::OnAction],
  ontimeout => Optional[Arc_ce::OnAction],
  plugin    => Stdlib::Unixpath,
  arguments => Optional[String],
}]
