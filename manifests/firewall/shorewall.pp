# This is used mainly by VPN/firewall systems
class profile::firewall::shorewall {
  include ::shorewall

  if $::shorewall::ipv4 {
    service { 'iptables':
      ensure => stopped,
      enable => false,
    }
  }

  if $::shorewall::ipv6 {
    service { 'ip6tables':
      ensure => stopped,
      enable => false,
    }
  }

  shorewall::config { 'STARTUP_ENABLED':
    value => 'Yes',
  }

  $shorewall_configs = lookup(
      'shorewall::configs',
      {
        default_value => {},
        value_type    => Hash,
      }
    )
  $shorewall_configs.each |$resource, $options| {
    shorewall::config { $resource:
      * => $options,
    }
  }

  $shorewall_ifaces = lookup(
      'shorewall::ifaces',
      {
        default_value => {},
        value_type    => Hash,
      }
    )
  $shorewall_ifaces.each |$resource, $options| {
    shorewall::iface { $resource:
      * => $options,
    }
  }

  $shorewall_zones = lookup(
      'shorewall::zones',
      {
        default_value => {},
        value_type    => Hash,
      }
    )
  $shorewall_zones.each |$resource, $options| {
    shorewall::zone { $resource:
      * => $options,
    }
  }

  $shorewall_policies = lookup(
      'shorewall::policies',
      {
        default_value => {},
        value_type    => Hash,
      }
    )
  $shorewall_policies.each |$resource, $options| {
    shorewall::policy { $resource:
      * => $options,
    }
  }

  $shorewall_masqs = lookup(
      'shorewall::masqs',
      {
        default_value => {},
        value_type    => Hash,
      }
    )
  $shorewall_masqs.each |$resource, $options| {
    shorewall::masq { $resource:
      * => $options,
    }
  }

  $shorewall_tunnels = lookup(
      'shorewall::tunnels',
      {
        default_value => {},
        value_type    => Hash,
      }
    )
  $shorewall_tunnels.each |$resource, $options| {
    shorewall::tunnel { $resource:
      * => $options,
    }
  }

  $shorewall_proxyarps = lookup(
      'shorewall::proxyarps',
      {
        default_value => {},
        value_type    => Hash,
      }
    )
  $shorewall_proxyarps.each |$resource, $options| {
    shorewall::proxyarp { $resource:
      * => $options,
    }
  }

  $shorewall_rules = lookup(
      'shorewall::rules',
      {
        default_value => {},
        value_type    => Hash,
      }
    )
  $shorewall_rules.each |$resource, $options| {
    shorewall::rule { $resource:
      * => $options,
    }
  }

  $shorewall_routestoppeds = lookup(
      'shorewall::routestoppeds',
      {
        default_value => {},
        value_type    => Hash,
      }
    )
  $shorewall_routestoppeds.each |$resource, $options| {
    shorewall::routestopped { $resource:
      * => $options,
    }
  }

  $shorewall_hosts = lookup(
      'shorewall::hosts',
      {
        default_value => {},
        value_type    => Hash,
      }
    )
  $shorewall_hosts.each |$resource, $options| {
    shorewall::host { $resource:
      * => $options,
    }
  }

  $shorewall_mangles = lookup(
      'shorewall::mangles',
      {
        default_value => {},
        value_type    => Hash,
      }
    )
  $shorewall_mangles.each |$resource, $options| {
    shorewall::mangle { $resource:
      * => $options,
    }
  }

  $shorewall_params = lookup(
      'shorewall::params',
      {
        default_value => {},
        value_type    => Hash,
      }
    )
  $shorewall_params.each |$resource, $options| {
    shorewall::param { $resource:
      * => $options,
    }
  }

}
