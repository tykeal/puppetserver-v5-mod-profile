# Firewall profile switch
class profile::firewall (
  Hash $rules = {},
) {
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
    include ::profile::firewall::iptables
  }

  $rules.each | String $resource, Hash $options | {
    ::profile::firewall::rule { $resource: * => $options }
  }
}
