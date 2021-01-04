# This is the base profile. This should be included by all roles that we have in
# use
class profile::base {
  include ::profile::admin
  include ::profile::auditd
  include ::profile::external_facts
  include ::profile::firewall
  # Configure git because it's just too useful to not have available
  include ::profile::git
  include ::profile::haveged
  # temporarily remove hosts management as there seems to be bug
  # when puppetdb isn't working yet
  include ::profile::hosts
  # ntp doesn't exist on EL8, I need to investigate a chrony module
  # include ::profile::ntp
  include ::profile::pam
  include ::profile::puppet::agent
  include ::profile::timezone
  include ::profile::selinux
  include ::profile::ssh
  include ::profile::sudo
  include ::profile::vim

  # hiera drive custom profile / class loads
  $custom_profiles = lookup(
    'custom_profiles',
    {
      'value_type'    => Variant[String,Array[String],Undef],
      'default_value' => undef,
    }
  )
  if ($custom_profiles) {
    lookup('custom_profiles', {merge => unique}).include
  }
}
