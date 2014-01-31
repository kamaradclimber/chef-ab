require 'rspec'

require_relative '../lib/chef-ab.rb'

describe ChefAB::HashUpgrader do
  it 'should have an integer hash' do
    up = ChefAB::HashUpgrader.new 5, nil, nil
    expect(up.hash).to be_a_kind_of(Integer)
  end
  it 'should have an integer hash in any case' do
    up = ChefAB::HashUpgrader.new "testing node", nil, nil
    expect(up.hash).to be_a_kind_of(Integer)
  end

  def future_upgrade
    ChefAB::HashUpgrader.new "testing node", (Time.now + 10), (Time.now + 3600)
  end
  def past_upgrade
    ChefAB::HashUpgrader.new "testing node", (Time.now - 10), (Time.now - 5)
  end

  it 'should not execute before start of upgrade' do
    expect(future_upgrade.should_execute?).to be_false
  end

  it 'should always execute after end of upgrade' do
    expect(past_upgrade.should_execute?).to be_true
  end

  it 'should not call block before start of upgrade' do
    expect { |b| future_upgrade.execute(&b) }.not_to yield_control
  end

  it 'should always call block after end of upgrade' do
    expect { |b| past_upgrade.execute(&b) }.to yield_control
  end

  def halfway_upgrade_early
    ChefAB::HashUpgrader.new 5, (Time.now - 10), (Time.now + 10)
  end
  it 'should call block for early nodes' do
    expect { |b| halfway_upgrade_early.execute(&b) }.to yield_control
  end

  def halfway_upgrade_late
    ChefAB::HashUpgrader.new 5, (Time.now - 10), (Time.now + 10)
  end

  it 'should not call block for late nodes' do
    expect { |b| halfway_upgrade_late.execute(&b) }.to yield_control
  end
end
