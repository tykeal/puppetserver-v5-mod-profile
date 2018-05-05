# setup the 10k robots!
class profile::r10k {
  include ::r10k
  include ::r10k::postrun_command
}
