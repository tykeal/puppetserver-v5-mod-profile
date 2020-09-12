# profile::web::roundcube
class profile::web::roundcube {
  include ::roundcube

  # Deal with creating the DB (we're only going to do mysql)
  $db_name = lookup(
    'roundcube::db_name',
    {
      default_value => 'roundcube',
      value_type    => String,
    }
  )

  $db_host = lookup(
    'roundcube::db_host',
    {
      default_value => 'localhost',
      value_type    => String,
    }
  )

  $db_username = lookup(
    'roundcube::db_username',
    {
      default_value => 'roundcube',
      value_type    => String,
    }
  )

  $db_password = lookup(
    'roundcube::db_password',
    {
      # no default, we want it to fail if it isn't set
      value_type => String,
    }
  )

  $roundcube_db_resource_tag = lookup(
    'roundcube::db_resource_tag',
    {
      # no default, we want it to fail if it isn't set
      value_type => String,
    }
  )

  $install_dir = lookup(
    'roundcube::install_dir',
    {
      # no default, we want it to fail if it isn't set
      value_type => Stdlib::Absolutepath,
    }
  )

  # the roundcube module doesn't manage the install dir location resource
  file { $install_dir:
    ensure => 'directory',
  }

  @@mysql::db { "roundcube_${::fqdn}":
    user     => $db_username,
    password => $db_password,
    dbname   => $db_name,
    host     => case $db_host {
                  'localhost': {
                    'localhost'
                  }
                  default: {
                    $::fqdn
                  }
                },
    grant    => ['ALL'],
    tag      => $roundcube_db_resource_tag,
  }
}
