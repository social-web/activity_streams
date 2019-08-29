# frozen_string_literal: true

module ActivityStreams
  def self.config
    @config ||= Configuration.instance
  end

  def self.configure
    yield config
  end

  class Configuration
    include Singleton

    attr_accessor :domain
  end
end
