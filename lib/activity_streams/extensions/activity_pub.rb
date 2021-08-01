# frozen_string_literal: true

module ActivityStreams
  module Extensions
    module ActivityPub
      def self.extended(base)
        base.class_eval do
          %i[inbox outbox following followers liked streams].each do |collection|
            property collection, type: PropertyTypes::Object
          end

          property :preferredUsername, type: PropertyTypes::String
        end
      end
    end
  end
end
