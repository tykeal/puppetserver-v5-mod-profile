# ::profile::dovecot
class profile::dovecot {
  include ::dovecot

  # load the dovcecot config to determine the cert name we should be acquiring
  $dovecot_config = lookup(
    'dovecot::config',
    {
      default_value => {},
      value_type    => Hash,
    }
  )

  if has_key($dovecot_config, 'hostname')
  {
    $cert_host = $dovecot_config['hostname']
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
  }

  # pops/imaps
  ::profile::firewall::rule { 'Enable POPS/IMAPS/SIEVE':
    priority => '645',
    proto    => 'tcp',
    dport    => ['993', '995', '4190'],
    state    => ['NEW'],
    action   => 'accept',
  }
}
