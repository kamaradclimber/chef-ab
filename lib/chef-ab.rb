require 'zlib'

module ChefAB
  class HashUpgrader

    attr_accessor :start_time, :end_time
    attr_accessor :node_id, :hash

    def initialize(node_id, start_time, end_time)
      @node_id = node_id
      if node_id.is_a? Integer
        @hash = node_id
      else
        @hash = Zlib.crc32 (node_id.to_s)
      end
      @start_time = start_time.to_i
      @end_time = end_time.to_i
    end

    def should_execute?
      upgrade_span = end_time - start_time
      threshold    = current_time - start_time
      (@hash % upgrade_span) < threshold
    end

    def execute(&block)
      if block_given? && should_execute?
        block.call
      end
    end

    private

    def current_time
      Time.now.to_i
    end

  end
end
