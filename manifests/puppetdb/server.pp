# Configure the puppetdb server
class profile::puppetdb::server {
  include ::puppetdb::server

  profile::firewall::rule { 'Puppetdb traffic from all':
    priority => '010',
    proto    => 'tcp',
    dport    => '8081',
    state    => ['NEW'],
    action   => 'accept',
  }
}
