# profile::db::mysql::server
class profile::db::mysql::server {
  include ::mysql::server

  $resourcetag = lookup(
    'mysql::resourcetag',
    {
      default_value => undef,
      value_type    => String,
    }
  )

  if ($resourcetag) {
    # collect any exported database definitions
    Mysql::Db <<| tag == $resourcetag |>>
  }
}
