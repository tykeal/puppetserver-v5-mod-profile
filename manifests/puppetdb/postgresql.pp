# puppetdb postgresql setup
class profile::puppetdb::postgresql {
  include ::puppetdb::database::postgresql

  profile::firewall::rule { 'Postgres traffic from all':
    priority => '010',
    proto    => 'tcp',
    dport    => '5432',
    state    => ['NEW'],
    action   => 'accept',
  }
}
