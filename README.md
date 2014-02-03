Chef AB
=======

chef-ab is a small library to activate code in cookbooks progressively in a cluster.

It works like an AB test with increasing population.


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

Another example, upgrading nodes exponentially depending on distance to a given ip address:

```ruby
# value before upgrade
default[:a_cookbook][:activate_experimental_feature] = false

# plumbing
start_time = Time.new(2014, 02, 11, 8, 30, 00, "+01:00")
period = 3600 # going larger every hour
first_node = "10.11.12.13"

upgrade = ChefAB::TimeIPBasedUpgrader.new node['ipaddress'],
  start_time,
  period,
  first_node

upgrade.execute do
  # value after upgrade
  default[:a_cookbook][:activate_experimental_feature] = true
end
```


Warning
----------



- This lib is **not** a substitute to release management, it will solve only the issue of progressive update.
- It is meant to replace the ssh loop that many uses to upgrades server farms.
- This library does not give strong garantees on the number of servers that will activate code at the same time (see chef_throttle for that).
