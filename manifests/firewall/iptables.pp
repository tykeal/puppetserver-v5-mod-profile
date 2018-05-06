# basic iptables rules are used by most systems
class profile::firewall::iptables {
  package { 'shorewall':
    ensure => absent,
  }

  resources { 'firewall':
    purge => hiera('firewall::purgerules',true),
  }
  Firewall {
    before  => Class['local_fw::post'],
    require => Class['local_fw::pre'],
  }
  class { ['::local_fw::pre', '::local_fw::post']: }
  class { '::firewall': }

  $firewall_chains = lookup(
      'firewall::chains',
      {
        default_value => {},
        value_type    => Hash,
      }
    )
  $firewall_chains.each |String $chain, Hash $options| {
    firewallchain { $chain:
      * => $options,
    }
  }

  $firewall_rules = lookup(
      'firewall::rules',
      {
        default_value => {},
        value_type    => Hash,
      }
    )
  $firewall_rules.each |String $rule, Hash $options| {
    firewall { $rule:
      * => $options,
    }
  }
}
