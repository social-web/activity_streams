# frozen_string_literal: true

require 'bundler/setup'

require 'http'
require 'json'

require 'activity_streams/errors'
require 'activity_streams/property_types'
require 'activity_streams/model'
require 'activity_streams/factory'
require 'activity_streams/internet'

module ActivityStreams
  NAMESPACE = 'https://www.w3.org/ns/activitystreams'

  class << self
    def from_json(json)
      Factory.new(json).build
    end
  end
end
