# Puppet master configuration
class profile::puppet::master {
  Ini_setting {
    ensure  => present,
    section => 'master',
    path    => "${::settings::confdir}/puppet.conf",
  }

  $puppetmaster = lookup(
      'puppet::master',
      {
        'value_type'    => Hash,
        'default_value' => {},
      }
    )

  # Create all of the configuration settings
  $puppetmaster.each |String $conf_setting, String $conf_value| {
    ini_setting { "puppet.conf/master/${conf_setting}":
      setting => $conf_setting,
      value   => $conf_value,
    }
  }
}
