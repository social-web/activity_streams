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
        result = yield
        @on = current
        result
      end
    end

    def off?
      !@on
    end

    def on?
      !!@on
    end

    def on(domain: nil, &blk)
      unless ActivityStreams.config.domain || domain
        warn <<~WARN.strip
          WARN: Turning on ActivityStreams access to the internet without a 
          domain configured risks an endless loop of requests to the domain that 
          ActivityStreams is loaded on. 

          Call `ActivityStreams.internet.on(domain: "example.com", &blk)` or use 
          `ActivityStreams.config.domain = "example.com"`
        WARN
      end

      current = @on
      @on = true

      if blk
        current_domain = ActivityStreams.config.domain
        ActivityStreams.config.domain = domain if domain

        result = yield

        @on = current
        ActivityStreams.config.domain = current_domain

        return result
      end

      @on
    end
  end
end
