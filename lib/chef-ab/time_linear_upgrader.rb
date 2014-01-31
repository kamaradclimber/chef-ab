module ChefAB
  class TimeLinearUpgrader < BaseUpgrader

    attr_accessor :start_time, :end_time

    def initialize(node_id, start_time, end_time)
      super(node_id)
      @start_time = start_time.to_i
      @end_time = end_time.to_i
      upgrade_span = end_time - start_time
      @hash = @hash % upgrade_span
    end

    def should_execute?
      threshold    = current_time - start_time
      super(threshold)
    end

    private

    def current_time
      Time.now.to_i
    end

  end
end
