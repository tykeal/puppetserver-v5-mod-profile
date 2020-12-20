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

  $acme_certificates.each |String $resource| {
    Acme::Certificate[$resource] ~> Class['nginx::service']
  }

  # $nginx_servers = lookup(
  #   'nginx::nginx_servers',
  #   {
  #     value_type => Hash,
  #   }
  # )

  # $nginx_servers.each |String $resource, Hash $options| {
  #   if has_key($options, 'ssl_cert')
  #   {
  #     File[$options['ssl_cert']] ~> Service['nginx']
  #   }
  #   if has_key($options, 'ssl_key')
  #   {
  #     File[$options['ssl_key']] ~> Service['nginx']
  #   }
  # }

  # http(s)
  ::profile::firewall::rule { 'Enable HTTP/HTTPS':
    priority => '030',
    proto    => 'tcp',
    dport    => ['80', '443'],
    state    => ['NEW'],
    action   => 'accept',
  }
}
