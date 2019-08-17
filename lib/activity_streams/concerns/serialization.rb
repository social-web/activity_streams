# frozen_string_literal: true

module ActivityStreams
  module Concerns
    module Serialization
      def unsupported_properties
        @unsupported_properties ||= {}
      end

      def unsupported_properties=(v)
        @unsupported_properties = v
      end

      def to_json(*args)
        JSON.dump(to_h)
      end

      def to_h
        props = properties.dup
        props.merge!( '@context' => _context ) if _context
        props.merge!(unsupported_properties) unless unsupported_properties.empty?
        props = self.is_a?(ActivityStreams::Activity::Update) ? props : props.compact
        props.transform_values do |v|
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
