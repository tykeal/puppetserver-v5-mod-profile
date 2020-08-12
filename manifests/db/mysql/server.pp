# profile::db::mysql::server
class profile::db::mysql::server {
  include ::mysql::server

  $resourcetag = lookup('mysql::resourcetag',
    {
      type    => String,
      default => undef,
    }
  )

  if ($resourcetag) {
    # collect any exported database definitions
    Mysql::Db <<| tag == $resourcetag |>>
  }
}
