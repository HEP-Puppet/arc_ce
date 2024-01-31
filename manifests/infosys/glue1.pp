# Class arc_ce::infosys::glue1
# Configures the infosys::glue1 block in arc.conf
class arc_ce::infosys::glue1 (
  String $resource_location,
  Float $resource_latitude,
  Float $resource_longitude,
  Numeric $cpu_scaling_reference_si00,
  String $processor_other_description,
  String $glue_site_web,
  String $glue_site_unique_id,
) {
  concat::fragment { 'arc.conf_infosys_glue1':
    target  => '/etc/arc.conf',
    content => template("${module_name}/infosys/glue1.erb"),
    order   => 38,
  }
}
