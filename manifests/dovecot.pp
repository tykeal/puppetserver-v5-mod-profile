# ::profile::dovecot
class profile::dovecot {
  include ::dovecot

  # pops/imaps
  ::profile::firewall::rule { 'Enable POPS/IMAPS':
    priority => '645',
    proto    => 'tcp',
    dport    => ['993', '995'],
    state    => ['NEW'],
    action   => 'accept',
  }
}
