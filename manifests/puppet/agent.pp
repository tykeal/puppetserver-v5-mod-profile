# Configure our puppet agents
class profile::puppet::agent {
  # We always enforce our puppt server instead of allowing the server to just
  # auto-discover off of the 'puppet' DNS lookup
  $puppetserver = lookup('puppetserver', String)

  Ini_setting {
    path   => "${::settings::confdir}/puppet.conf",
    ensure => present,
    notify => Service['puppet'],
  }

  ini_setting { 'puppet.conf/agent/report':
    section => 'agent',
    setting => 'report',
    value   => true,
  }

  ini_setting { 'puppet.conf/main/server':
    section => 'agent',
    setting => 'server',
    value   => $puppetserver,
  }

  # load settings that should be in the global puppet main section
  $puppetmain = lookup('puppet::main',
    {
      value_type    => Hash,
      default_value => {},
    }
  )
  $puppetmain.each |String $conf_setting, String $conf_value| {
    ini_setting { "puppet.conf/main/${conf_setting}":
      section => 'main',
      setting => $conf_setting,
      value   => $conf_value,
    }
  }

  # /opt/puppetlabs/puppet/cache needs 0711 so that nrpe can traverse it to read
  # the state file we monitor
  # file { '/opt/puppetlabs/puppet/cache':
  #   ensure => directory,
  #   mode   => '0711',
  # }

  # Always make sure puppet agent is running. If the agent needs to be disabled,
  # then 'puppet agent --disable "reason"' should be executed on the host.
  # Reason needs to be double quoted
  service { 'puppet':
    ensure => running,
    enable => true,
  }
}
