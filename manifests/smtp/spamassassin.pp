# profile::smtp::spamassassin
class profile::smtp::spamassassin {
  include ::spamassassin
  include ::spamass_milter
}
