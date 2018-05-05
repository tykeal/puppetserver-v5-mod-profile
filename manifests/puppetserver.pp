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
}
