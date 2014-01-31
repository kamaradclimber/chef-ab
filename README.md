Chef AB
=======

chef-ab is a small library to activate code in cookbooks progressively in a cluster.

It works like an AB test with increasing population.

This library does not give strong garantees on the number of servers that will activate code at the same time (see chef_throttle for that).

Usage
----------

Very simple example in attribute file of :

```ruby
# value before upgrade
default[:a_cookbook][:activate_experimental_feature] = false

# plumbing
one_week_in_secs = 7 * 86400
start_time = Time.new(2014, 02, 11, 8, 30, 00, "+01:00")
end_time = start_time + one_week_in_secs

upgrade = ChefAB::TimeLinearUpgrader.new(
  node['fqdn'], # we use fqdn as id for the migration
  start_time,
  end_time
)

upgrade.execute do
  # value after upgrade
  default[:a_cookbook][:activate_experimental_feature] = true
end

# sugar for easy status collect
default[:chef_ab][:experimental_feature_activation] = Time.at(upgrade.expected_activation)
default[:chef_ab][:experimental_feature_activated] = node[:a_cookbook][:activate_experimental_feature]
```
