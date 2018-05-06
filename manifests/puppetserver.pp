# Puppet servers (which are technically also masters)
class profile::puppetserver {

  # Script for easy decommissioning of nodes
  file { '/usr/local/bin/decommission_node.sh':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0500',
    source => "puppet:///modules/${module_name}/puppet/decommission_node.sh",
  }

  # Firewall configuration
  profile::firewall::rule { 'Puppet master trafic from all':
    priority => '010',
    proto    => 'tcp',
    dport    => '8140',
    state    => ['NEW'],
    action   => 'accept',
  }
}
