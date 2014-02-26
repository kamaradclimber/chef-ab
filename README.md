Chef AB
=======
[![Build Status](https://travis-ci.org/criteo/chef-ab.png?branch=master)](https://travis-ci.org/criteo/chef-ab)
[![Gem Version](https://badge.fury.io/rb/chef-ab.png)](http://badge.fury.io/rb/chef-ab)
[![Dependency Status](https://gemnasium.com/criteo/chef-ab.png)](https://gemnasium.com/criteo/chef-ab)

chef-ab is a small library to activate code in cookbooks progressively in a cluster.

It works like an AB test with increasing population.


Usage
----------

Very simple example in attribute file of :

```ruby
# value before upgrade
default[:a_cookbook][:activate_experimental_feature] = false

upgrade = ChefAB::TimeLinearUpgrader.new(
  node_id: node['fqdn'], # we use fqdn as id for the migration
  start_time: Time.new(2014, 02, 11, 8, 30, 00, "+01:00"),
  end_time:   Time.new(2014, 02, 18, 8, 30, 00, "+01:00")
)

upgrade.execute do
  default[:a_cookbook][:activate_experimental_feature] = true
end
```

Another example, upgrading nodes exponentially depending on distance to a given ip address:

```ruby
# value before upgrade
default[:a_cookbook][:activate_experimental_feature] = false

upgrade = ChefAB::TimeIPBasedUpgrader.new(
  node_id: node['ipaddress'],
  start_time: Time.new(2014, 02, 11, 8, 30, 00, "+01:00"),
  period: 3600, #going larger every hour
  initial_ip: "10.11.12.13"
)

upgrade.execute do
  default[:a_cookbook][:activate_experimental_feature] = true
end
```


Warning
----------



- This lib is **not** a substitute to release management, it will solve only the issue of progressive update.
- It is meant to replace the ssh loop that many uses to upgrades server farms.
- This library does not give strong garantees on the number of servers that will activate code at the same time (see chef_throttle for that).
