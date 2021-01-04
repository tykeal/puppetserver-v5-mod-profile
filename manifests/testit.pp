# Vim profile
class profile::testit {
  file { '/root/testit':
    ensure => present,
    owner  => 'root',
    group  => 'tykeal',
  }
}
