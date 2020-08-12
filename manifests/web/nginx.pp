# nginx webserver
class profile::web::nginx {
  include ::nginx

  # allow nginx to set rlimit
  selboolean { 'httpd_setrlimit':
    persistent => true,
    value      => on,
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
