# SELinux setup
class profile::selinux {
  include ::selinux::base

  # Configure hiera managed fcontexts
  $fcontexts = lookup(
      'selinux::fcontexts',
      {
        'value_type'    => Hash,
        'default_value' => {},
      }
    )

  $fcontexts.each |$resource, $options| {
    ::selinux::fcontext { $resource:
      * => $options,
    }
  }
}
