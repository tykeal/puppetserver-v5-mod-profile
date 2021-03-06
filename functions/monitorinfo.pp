# function profile::monitorinfo
function profile::monitorinfo() >> Struct[{
  enable               => Boolean,
  nagios_plugin_dir    => Stdlib::AbsolutePath,
  defaultserviceconfig => Hash,
}] {
  include ::nagios::params
  $monitor_info = {
    enable               => (lookup(
      'production_ready',
      {
        default_value => false,
        value_type    => Boolean,
      }
    ) or (lookup(
      'lfcorehost',
      {
        default_value => false,
        value_type    => Boolean,
      }
    ))),
    defaultserviceconfig => lookup(
      'nagios::client::defaultserviceconfig',
      {
        default_value => $::nagios::params::defaultserviceconfig,
        value_type    => Hash,
      }
    ),
    nagios_plugin_dir    => lookup(
      'nagios_plugin_dir',
      {
        default_value => '/usr/lib64/nagios/plugins',
        value_type    => Stdlib::AbsolutePath,
      }
    ),
  }
}
