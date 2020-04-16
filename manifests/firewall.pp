# Firewall profile switch
class profile::firewall {
  $use_shorewall = lookup(
      'profile::firewall::use_shorewall',
      {
        default_value => false,
        value_type    => Boolean,
      }
    )

  if $use_shorewall {
    include ::profile::firewall::shorewall
  } else {
    case $facts['os']['name'] {
      'RedHat', 'CentOS': {
        if $facts['os']['major'] >= 8 {
          include ::profile::firewall::firewalld
        } else {
          include ::profile::firewall::iptables
        }
      }
      Default: {
        notice('Unsupported OS for firewall')
      }
    }
  }
}
