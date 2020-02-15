# frozen_string_literal: true

require 'singleton'

module ActivityStreams
  def self.config
    @config ||= Configuration.instance
  end

  def self.configure
    yield config
  end

  class Configuration
    include ::Singleton

    attr_accessor :accessor_methods
  end
end
