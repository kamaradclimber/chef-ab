require 'rspec'
require_relative '../lib/chef-ab.rb'

describe ChefAB::BaseUpgrader do
  it 'should have an integer hash' do
    up = ChefAB::BaseUpgrader.new 5
    expect(up.hash).to be_a_kind_of(Integer)
  end
  it 'should have an integer hash in any case' do
    up = ChefAB::BaseUpgrader.new "testing node"
    expect(up.hash).to be_a_kind_of(Integer)
  end
end
