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
        'default_value' => {}.
        'value_type'    => Hash,
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
