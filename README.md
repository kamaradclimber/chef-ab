Chef AB
-------

chef-ab is a small library to activate code in cookbooks progressively in a cluster.

It works like an AB test with increasing population.

This library does not give strong garantees on the number of servers that will activate code at the same time (see chef_throttle for that).

Use how-to
====

Very simple example in attribute file of :

```ruby
default[:a_cookbook][:activate_experimental_feature] = false

one_week_in_secs = 7 * 86400
start_time = Time.new(2014, 02, 11, 8, 30, 00, "+01:00")
end_time = start_time + one_week_in_secs
upgrade = ChefAB::TimeLinearUpgrader.new node['fqdn'], start_time, end_time

upgrade.execute do
  default[:a_cookbook][:activate_experimental_feature] = true
end
```
