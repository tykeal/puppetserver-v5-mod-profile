# Class profile::testit
class profile::testit {
  $teststruct = lookup('testit::teststruct',
    {
      default_value => {},
      value_type    => Hash[
                        Stdlib::Fqdn,
                        Struct[{port => Integer}],
                        0],
          #value_type    => Variant[
          #  {},
          #  Hash[Stdlib::Fqdn, Struct[{port => Integer}]],
          #],
    })

  if $teststruct {
    notify("teststruct '${teststruct}' exists")
  }
}
