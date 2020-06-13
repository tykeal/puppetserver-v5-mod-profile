# class ::profile::postifx
class profile::postfix {
  include ::postfix

  # Always force transport maps to be created even when not being pushed
  Postfix::Transport {
    require => Exec['force transport rebuild'],
  }

  exec { 'force transport rebuild':
    path    => '/usr/bin:/usr/sbin:/bin',
    command => 'rm -f /etc/postfix/transport{,.db}',
    unless  => 'rpm -V postfix | grep -q transport',
    require => Class['::postfix::packages'],
  }

  # load postfix configs and add any extra packages that may be needed
  $postfix_configs = lookup(
    'postfix::configs',
    {
      default_value => {},
      value_type    => Hash,
    }
  )

  if 'smtp_sasl_auth_enable' in keys($postfix_configs) {
    if $postfix_configs['smtp_sasl_auth_enable']['value'] == 'yes' {
      ensure_packages(
        [
          'cyrus-sasl-plain'
        ],
        {
          'ensure' => 'present',
        }
      )
    }
  }

  $postfix_transports = lookup(
    'postfix::transports',
    {
      default_value => {},
      value_type    => Hash,
    }
  )
  $postfix_transports.each |String $resource, Hash $options| {
    ::postfix::transport { $resource:
      * => $options,
    }
  }

  $postfix_virtuals = lookup(
    'postfix::virtuals',
    {
      default_value => {},
      value_type    => Hash,
    }
  )
  $postfix_virtuals.each |String $resource, Hash $options| {
    ::postfix::virtual { $resource:
      * => options,
    }
  }

  $mta = lookup(
    'postfix::mta',
    {
      default_value => false,
      value_type    => Boolean,
    }
  )
  if ($mta) {
    # SMTP operates on port 25 by definition, if the server isn't operating
    # on that port there is likely a problem
    ::profile::firewall::rule { 'Accept all SMTP traffic':
      priority => '025',
      proto    => 'tcp',
      dport    => ['25'],
      state    => ['NEW'],
      action   => 'accept',
    }
  }
}
