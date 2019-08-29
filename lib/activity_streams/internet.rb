# frozen_string_literal: true

module ActivityStreams
  def self.internet
    @internet ||= Internet.instance
  end

  class Internet
    include Singleton

    def initialize
      @on = false
    end

    def off &blk
      current = @on
      @on = false
      if blk
        yield
        @on = current
      end
    end

    def off?
      !@on
    end

    def on?
      !!@on
    end

    def on &blk
      current = @on
      @on = true
      if blk
        yield
        @on = current
      end
    end
  end
end
