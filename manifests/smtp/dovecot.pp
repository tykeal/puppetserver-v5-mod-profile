# ::profile::smtp::dovecot
class profile::smtp::dovecot {
  include ::dovecot

  $cert_host = lookup(
    'dovecot::cert',
    {
      value_type => String,
    }
  )

  # generate a 4096 DH key
  openssl::dhparam { '/etc/pki/dovecot/private/dh.pem':
    size   => 4096,
    owner  => 'dovecot',
    group  => 'dovecot',
    mode   => '0600',
    before => Class['dovecot::service'],
    notify => Class['dovecot::service'],
  }

  # load the acme certificate values as we're going to call a define and those
  # don't auto-lookups
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
    'acme::certificate::ca',
    {
      # This is allowed to be undef (defaults to production)
      default_value => undef,
      value_type    => String,
    }
  )

  ::acme::certificate { $cert_host :
    use_account => $acme_use_account,
    use_profile => $acme_use_profile,
    ca          => $acme_le_ca,
    notify      => Class['dovecot::service'],
  }

  # pops/imaps
  ::profile::firewall::rule { 'Enable POP3/POP3S/IMAP/IMAPS/SIEVE':
    priority => '645',
    proto    => 'tcp',
    dport    => ['110', '143', '993', '995', '4190'],
    state    => ['NEW'],
    action   => 'accept',
  }

  # setup global sieve filters if sieve is being loaded
  $dovecot_plugins = lookup(
    'dovecot::plugins',
    {
      default_value => undef,
      value_type    => Optional[Array[String]],
    }
  )

  if (($dovecot_plugins) and ('sieve' in $dovecot_plugins)) {
    file { '/etc/dovecot/sieve':
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      purge  => true,
    }

    $sieve_filters = lookup(
      'dovecot::sieve_filters',
      {
        default_value => [],
        value_type    => Array[String],
      }
    )

    $sieve_filters.each |String $filter| {
      dovecot::sieve { "/etc/dovecot/sieve/${filter}.sieve":
        source => "puppet:///modules/${module_name}/dovecot/sieve/${filter}.sieve",
      }
    }
  }
}
