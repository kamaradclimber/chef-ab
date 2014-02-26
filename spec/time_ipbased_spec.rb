require_relative 'spec_helper.rb'

module ChefAB
  class TimeIPBasedUpgrader
    attr_accessor :current_timer
    def current_time
      @current_timer || Time.now.to_i
    end
  end
end

describe ChefAB::TimeIPBasedUpgrader do

  def future_upgrade
    ChefAB::TimeIPBasedUpgrader.new(
      node_id: "192.168.17.1",
      start_time: Time.now + 10,
      period: 3600,
      initial_ip: "192.168.17.1"
    )
  end
  def past_upgrade
    ChefAB::TimeIPBasedUpgrader.new(
      node_id: "192.168.17.1",
      start_time: Time.now - 10,
      period: 3600,
      initial_ip: "192.168.17.1"
    )
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

  it 'should not call block before expected_activation and should always do after' do
    start_time = 42 #any timestamp
    period = 10
    up = ChefAB::TimeIPBasedUpgrader.new(
      node_id: "192.168.18.23",
      start_time: start_time,
      period: period,
      initial_ip: "192.168.17.1"
    )

    end_time = 42 + 32 * period

    first_execute_time = up.expected_activation

    (start_time..first_execute_time-1).each do |fake_time|
      up.current_timer = fake_time
      expect { |b| up.execute(&b) }.not_to yield_control
    end
    (first_execute_time..end_time).each do |fake_time|
      up.current_timer = fake_time
      expect { |b| up.execute(&b) }.to yield_control
    end
  end
end
