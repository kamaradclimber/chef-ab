require 'zlib'

module ChefAB
  class BaseUpgrader
    attr_accessor :node_id, :hash

    def initialize(options)
      @node_id = options[:node_id]
      raise "node_id is a mandatory options" unless @node_id
      if @node_id.is_a? Integer
        @hash = node_id
      else
        @hash = Zlib.crc32 (@node_id.to_s)
      end
    end

    def should_execute?(threshold)
      @hash < threshold
    end

    def execute(&block)
      if block_given? && should_execute?
        block.call
      end
    end
  end
end
