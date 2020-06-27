# profile::smtp::maildir
class profile::smtp::maildir {
  # we host our user mail in Maildirs
  #
  # should we create a new user we want them to get that setup correctly
  # so we need to make sure that the Maildir structure exists in /etc/skel
  file {
    [
      '/etc/skel/Maildir',
      '/etc/skel/Maildir/cur',
      '/etc/skel/Maildir/new',
      '/etc/skel/Maildir/tmp',
    ]:
    ensure => directory,
    group  => 'root',
    mode   => '0700',
    owner  => 'root',
  }
}
