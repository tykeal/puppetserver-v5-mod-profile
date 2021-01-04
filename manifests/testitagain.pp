# Vim profile
class profile::testitagain {
  file { '/root/testitagain':
    ensure => present,
    owner  => 'root',
    group  => 'tykeal',
  }
}
