# nginx webserver
class profile::web::nginx {
  include ::nginx

  # allow nginx to set rlimit
  selboolean { 'httpd_setrlimit':
    persistent => true,
    value      => on,
  }

  # We need to force Nginx to refresh anytime the cert(s) get updated
  $acme_certificates = lookup(
    'acme::certificates',
    {
      value_type => Hash,
    }
  )

  $acme_certificates.each |String $resource, Hash $options| {
    Acme::Certificate[$resource] ~> Class['nginx::service']
  }

  # http(s)
  ::profile::firewall::rule { 'Enable HTTP/HTTPS':
    priority => '030',
    proto    => 'tcp',
    dport    => ['80', '443'],
    state    => ['NEW'],
    action   => 'accept',
  }
}
