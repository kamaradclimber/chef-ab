require 'ipaddress'
require 'backports/2.0.0/array/bsearch'

module IPmetric
  def ip_metric(ip_ref, ip)
    ip1 = IPAddress.parse(ip_ref)
    ip2 = IPAddress.parse(ip)
    dist = (0..32).to_a.reverse.bsearch do |mask|
      ip1.prefix = mask
      ip1.include?(ip2)
    end
    32 - dist
  end
end
