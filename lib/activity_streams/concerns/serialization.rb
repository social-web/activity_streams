# frozen_string_literal: true

module ActivityStreams
  module Concerns
    module Serialization
      attr_accessor :unsupported_context
      attr_accessor :unsupported_properties

      def to_json(*args)
        JSON.dump(to_h)
      end

      def to_h
        attrs = attributes.dup
        if unsupported_properties
          attrs.merge!(unsupported_properties)
        end
        attrs = self.is_a?(ActivityStreams::Activity::Update) ? attrs : attrs.compact
        attrs.transform_values do |v|
          case v
          when ActivityStreams::Model then v.to_h
          when Date, Time then v.iso8601
          else v
          end
        end
      end
    end
  end
end
