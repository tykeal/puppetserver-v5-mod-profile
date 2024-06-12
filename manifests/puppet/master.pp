# Puppet master configuration
class profile::puppet::master (
  String $report_ttl = '1w',
) {
  Ini_setting {
    ensure  => present,
    section => 'master',
    path    => "${::settings::confdir}/puppet.conf",
  }

  $puppetmaster = lookup(
      'puppet::master',
      {
        value_type    => Hash,
        default_value => {},
      }
    )

  # Create all of the configuration settings
  $puppetmaster.each |String $conf_setting, String $conf_value| {
    ini_setting { "puppet.conf/master/${conf_setting}":
      setting => $conf_setting,
      value   => $conf_value,
    }
  }

  # Create a cron job that fires once a day to enable log cleaning
  file { '/etc/cron.daily/flag_puppet_tidy':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0744',
    source => "puppet:///modules/${module_name}/puppet/flag_puppet_tidy",
  }

  tidy { 'tidy puppet reports':
    path    => '/opt/puppetlabs/server/data/puppetserver/reports',
    age     => $report_ttl,
    recurse => true,
    matches => [ '*.yaml' ],
    rmdirs  => true,
  }
}
