require_relative 'spec_helper.rb'

describe IPMetric do
  include IPMetric
  it 'should give metric zero between an address and itself' do
    dist = ip_metric("192.168.0.34", "192.168.0.34")
    expect(dist).to eq(0)
  end
  it 'should give metric 1 between an address and neighbour' do
    dist = ip_metric("192.168.0.34", "192.168.0.35")
    expect(dist).to eq(1)
  end
  it 'should give metric 8 between an address and next block' do
    dist = ip_metric("192.168.0.34", "192.168.1.35")
    expect(dist).to eq(9)
  end
  it 'should give metric 32 between lowest and highest' do
    dist = ip_metric("0.0.0.0", "255.255.255.255")
    expect(dist).to eq(32)
  end
end
