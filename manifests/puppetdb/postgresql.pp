# puppetdb postgresql setup
class profile::puppetdb::postgresql {
  include ::puppetdb::database::postgresql
}
