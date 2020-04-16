# firewalld configuration used on EL8+
class profile::firewall::firewalld {
  package { 'shorewall':
    ensure => absent,
  }

  # we presently don't do configuration, this will come!
  notice('firewalld not configured yet!')
}
