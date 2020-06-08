# acme Let's Encrypt
class profile::acme {
  # camptocamp/openssl is required for acme to work correctly
  require ::openssl
  include ::acme
}
