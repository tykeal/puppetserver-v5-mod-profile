# Configure auditd
class profile::auditd {
  include ::auditd

  if lookup('auditd::enable_syslog',
    { 'default_value' => false }) {
    include ::auditd::audisp::syslog
  }
}
