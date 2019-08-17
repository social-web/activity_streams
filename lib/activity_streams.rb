# frozen_string_literal: true

require 'bundler/setup'

require 'json'

require 'activity_streams/errors'
require 'activity_streams/property_types'
require 'activity_streams/model'
require 'activity_streams/factory'

module ActivityStreams
  class << self
    def from_json(json)
      Factory.new(json).build
    end
  end
end
