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

  # The rest of the values should properly load from hiera
  ::acme::certificate { $cert_host : }

  # pops/imaps
  ::profile::firewall::rule { 'Enable POPS/IMAPS':
    priority => '645',
    proto    => 'tcp',
    dport    => ['993', '995'],
    state    => ['NEW'],
    action   => 'accept',
  }
}
