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
  include ::profile::hosts
  include ::profile::ntp
  include ::profile::pam
  include ::profile::puppet::agent
  include ::profile::timezone
  include ::profile::selinux
  include ::profile::ssh
  include ::profile::sudo
  include ::profile::vim

  # we haven't ported anything yet, it's just empty

  # hiera drive custom porfile / class loads
  $custom_profiles = lookup(
    'custom_profiles',
    {
      'value_type'    => Variant[Array,Undef],
      'default_value' => undef,
    }
  )
  #$custom_profiles = hiera_array('custom_profiles', undef)
  if ($custom_profiles) {
    hiera_include('custom_profiles')
  }
}
