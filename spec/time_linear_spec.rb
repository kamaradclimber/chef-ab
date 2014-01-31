require 'rspec'

require_relative '../lib/chef-ab.rb'

module ChefAB
  class TimeLinearUpgrader
    attr_accessor :current_timer
    def current_time
      @current_timer || Time.now.to_i
    end
  end
end

describe ChefAB::TimeLinearUpgrader do

  def future_upgrade
    ChefAB::TimeLinearUpgrader.new "testing node", (Time.now + 10), (Time.now + 3600)
  end
  def past_upgrade
    ChefAB::TimeLinearUpgrader.new "testing node", (Time.now - 10), (Time.now - 5)
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

  it 'should not call block before due time and should always do after' do
    start_time = 42 #any timestamp
    end_time = 60
    up = ChefAB::TimeLinearUpgrader.new "testing node", start_time, end_time

    first_execute_time = start_time + (start_time..end_time).to_a.index do |fake_time|
      up.current_timer = fake_time
      up.should_execute?
    end


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
