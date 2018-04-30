# This is the base profile. This should be included by all roles that we have in
# use
class profile::base {
  # we haven't ported anything yet, it's just empty

  # hiera drive custom porfile / class loads
  $custom_profiles = hiera_array('custom_profiles', undef)
  if ($custom_profiles) {
    hiera_include('custom_profiles')
  }
}
