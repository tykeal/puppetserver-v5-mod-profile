# class ::profile::smtp::postifx
class profile::smtp::postfix {
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
    # Additionally open 587 (submission)
    ::profile::firewall::rule { 'Accept all SMTP traffic':
      priority => '025',
      proto    => 'tcp',
      dport    => ['25', '587'],
      state    => ['NEW'],
      action   => 'accept',
    }
  }

  if has_key($postfix_configs, 'myhostname')
  {
    $cert_host = $postfix_configs['myhostname']['value']
  }

  # load the acme certificate values as we're going to call a define and those
  # don't do auto-lookups
  $acme_use_account = lookup(
    'acme::certificate::use_account',
    {
      # no default value as it's required to be set
      value_type => String,
    }
  )

  $acme_use_profile = lookup(
    'acme::certificate::use_profile',
    {
      # no default value as it's required to be set
      value_type => String,
    }
  )

  $acme_le_ca = lookup(
    'acme::certificate::letsencrypt_ca',
    {
      # This is allowed to be undef (defaults to production)
      default_value => undef,
      value_type    => String,
    }
  )

  ::acme::certificate { $cert_host :
    use_account    => $acme_use_account,
    use_profile    => $acme_use_profile,
    letsencrypt_ca => $acme_le_ca,
    notify         => Class['postfix::service'],
  }

}
