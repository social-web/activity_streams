# frozen_string_literal: true

module ActivityStreams
  module Core
    ActivityStreams.register_context(
      'https://www.w3.org/ns/activitystreams', self
    )

    def self.extended(mod)
      mod.class_eval do
        property :_context, PropertyTypes::String
        property :type, PropertyTypes::String
      end
    end
  end
end
