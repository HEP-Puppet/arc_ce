# Define arc_ce::arex::jura_apel
# Configures a jura apel target block in arc.conf
define arc_ce::arex::jura_apel(
  Optional[Stdlib::HTTPSUrl] $targeturl = undef,
  String $topic = '/queue/global.accounting.cpu.central',
  Optional[String] $gocdb_name = undef,
  Arc_ce::ApelMessage $apel_messages = 'summaries',
  Array[String] $vofilter = [],
  Integer $urbatchsize = 1000,
  Integer $urdelivery_frequency = 86000,
) {

  concat::fragment { "arc.conf_arex_jura_apel_${name}":
    target  => '/etc/arc.conf',
    content => template("${module_name}/arex/jura_apel.erb"),
    order   => 27,
  }

}
