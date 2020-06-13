# Administrative configuration
class profile::admin {
  include ::epel

  # administrative packages that we want on systems that don't need full blown
  # modules for managing them
  $admin_packages = [
    'bind-utils',
    'htop',
    'iftop',
    'iotop',
    'mtr',
    'net-tools', # yes many of these are obsolete, but I like some of them!
    'nmap-ncat',
    'screen',
    'tcpdump',
    'traceroute',
    'tree',
    'unzip'
  ]

  ensure_packages( $admin_packages,
    { 'ensure' =>  'installed' })

  #
  ## Scripts
  #
  # https://github.com/yrro/psdel
  file { '/usr/local/sbin/psdel':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => "puppet:///modules/${module_name}/admin/scripts/psdel",
  }

  # https://github.com/mricon/puppet-eyes
  file { '/usr/share/vim/vimfiles/plugin':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Package['vim-common'],
  }
  file { '/usr/share/vim/vimfiles/plugin/puppet_eyes.vim':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => "puppet:///modules/${module_name}/admin/scripts/puppet_eyes.vim",
  }
}
