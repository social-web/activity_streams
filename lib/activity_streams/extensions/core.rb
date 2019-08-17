# frozen_string_literal: true

module ActivityStreams
  module Core
    ActivityStreams.register_context(
      'https://www.w3.org/ns/activitystreams', self
    )

    def self.extended(mod)
      mod.class_eval do
        property :_context, Types::String
        property :type, Types::String
      end
    end
  end
end
