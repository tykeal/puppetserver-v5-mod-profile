# nginx webserver
class profile::nginx {
  include ::nginx

  # http(s)
  ::profile::firewall::rule { 'Enable HTTP/HTTPS':
    priority => '030',
    proto    => 'tcp',
    dport    => ['80', '443'],
    state    => ['NEW'],
    action   => 'accept',
  }
}
