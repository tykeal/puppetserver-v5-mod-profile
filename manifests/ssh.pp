# Configure ssh
class profile::ssh {
  # all systems need to have ssh configured
  include ::ssh

  $ssh_server_options = lookup(
      'ssh::server_options',
      {
        default_value => {},
        value_type    => Hash,
      }
    )

  if 'Port' in $ssh_server_options and
    $ssh_server_options =~ Stdlib::Port
  {
    $dport = $ssh_server_options['Port']
  }
  else
  {
    $dport = 22
  }

  # ::ssh can collect all known hosts, but we don't like doing as we may have a
  # lot of hsots in the environment. It's better to just push known hosts when
  # needed
  $known_hosts = lookup(
      'ssh::known_hosts',
      {
        default_value => {},
        value_type  => Hash,
      }
    )
  $known_hosts.each |String $resource, Hash $options| {
    sshkey { $resource:
      * => $options,
    }
  }

  $ssh_host_keys = lookup(
      'ssh::server::host_keys',
      {
        default_value => {},
        value_type  => Hash,
      }
    )
  $ssh_host_keys.each |String $resource, Hash $options| {
    ssh::server::host_key { $resource:
      * => $options,
    }
  }

  # firewall configuration
#  $_allow_from = lookup(
#      'ssh::firewall_allow_from',
#      {
#        default_value => [],
#        value_type  => Array,
#      }
#    )
#
#  if length($_allow_from) > 0 {
#    # To avoid completely locking folks out, this can be set high in the hiera
#    # so that a hiera specific IP address is always allowed
#    $_always_allow_from = lookup(
#        'ssh::firewall_always_allow_from',
#        {
#          default_value => [],
#          value_type  => Array,
#        }
#      )
#
#    # Our finalized allow from array
#    $firewall_allow_from = concat($_always_allow_from, $_allow_from)
#
#    # Build the final rules
#    unique($firewall_allow_from).each |String $source| {
#      Stdlib::Compat::Ip_address($source)
#    }
#  }

  # Default to just allowing from all places right now
  profile::firewall::rule { 'SSH traffic from all':
    priority => '005',
    proto    => 'tcp',
    dport    => $dport,
    state    => ['NEW'],
    action   => 'accept',
  }
}
