# that sudo that you do
class profile::sudo {
  include ::sudo
  include ::sudo::configs
}
