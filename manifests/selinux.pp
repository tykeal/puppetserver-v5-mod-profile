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

  # configure hiera managed selbooleans
  $selbooleans = lookup(
    'selinux::selbooleans',
    {
      value_type    => Hash,
      default_value => {},
    }
  )

  $selbooleans.each |$resource, $options| {
    ::selboolean { $resource:
      * => $options,
    }
  }
}
