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

    def off
      @on = false
    end

    def off?
      !@on
    end

    def on?
      !!@on
    end

    def on
      @on = true
    end
  end
end
