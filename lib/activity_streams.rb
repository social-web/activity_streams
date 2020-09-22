# frozen_string_literal: true

require 'bundler/setup'

require 'json'
require 'json/ld'
require 'securerandom'

require 'activity_streams/configuration'
require 'activity_streams/errors'
require 'activity_streams/property_types'
require 'activity_streams/model'
require 'activity_streams/factory'
require 'activity_streams/utilities/queue'

module ActivityStreams
  NAMESPACE = 'https://www.w3.org/ns/activitystreams'

  class << self
    def ===(obj)
      obj.is_a?(ActivityStreams)
    end

    def from_hash(hash)
      type = hash[:type]
      self.types_registry[type].new(hash)
    end

    def from_json(json)
      Factory.new(json).build
    end

    def generate_random(props = {})
      model = types_registry[props[:type]] || types_registry.values.sample
      properties = model.properties.select { |k, v| !%i[@context type].include?(k) }
      instance = model.new
      properties.each do |prop, type|
        instance[prop] = case type
        when PropertyTypes::DateTime then Time.now
        when PropertyTypes::IRI
          "https://example.org/#{SecureRandom.hex}"
        when PropertyTypes::Any then SecureRandom.hex
        else raise "Failed to set prop: #{prop} of type: #{type} on instance: #{instance}"
        end
      end

      instance.merge_properties(props)

      instance
    end
  end
end
