# nginx webserver
class profile::web::nginx {
  include ::nginx

  # allow nginx to set rlimit
  selboolean { 'httpd_setrlimit':
    persistent => true,
    value      => on,
  }

  # We need to force Nginx to refresh anytime the cert(s) get updated
  $nginx_servers = lookup(
    'nginx::nginx_servers',
    {
      value_type => Hash,
    }
  )

  $nginx_servers.each |String $resource, Hash $options| {
    if has_key($options, 'ssl_cert')
    {
      notify {$options['ssl_cert']: }
      # 0File[$options['ssl_cert']] ~> Service['nginx']
    }
    if has_key($options, 'ssl_key')
    {
      notify {$options['ssl_key']: }
      # File[$options['ssl_key']] ~> Service['nginx']
    }
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
