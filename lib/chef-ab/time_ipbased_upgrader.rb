require 'ipaddress'

module ChefAB
  class TimeIPBasedUpgrader < BaseUpgrader

    include IPmetric

    attr_accessor :start_time, :period
    attr_accessor :initial_ip

    def initialize(options)
      options[:node_id] = ip_metric(options[:initial_ip], options[:node_id])
      super(options)
      @start_time = options[:start_time].to_i
      @period = options[:period]
      @end_time = 31 * @period + @start_time
    end

    def should_execute?(time = nil)
      time ||= current_time
      threshold    = (time - start_time) / @period + 1
      super(threshold)
    end

    def expected_activation
      (@start_time..@end_time).to_a.bsearch do |fake_time|
        should_execute?(fake_time)
      end
    end

    private

    def current_time
      Time.now.to_i
    end
  end
end
