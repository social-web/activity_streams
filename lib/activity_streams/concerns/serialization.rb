# frozen_string_literal: true

require 'ostruct'

module ActivityStreams
  module Concerns
    module Serialization
      def _unsupported_properties
        @_unsupported_properties ||= {}
      end

      def _unsupported_properties=(v)
        @_unsupported_properties = v
      end

      def to_json(*args)
        to_h.
          transform_values { |v| convert_to_json(v) }.
          to_json
      end

      def to_h
        properties.dup
      end

      private

      def convert_to_json(v)
        case v
        when ActivityStreams then v.to_h
        when Array then v.map { |vv| convert_to_json(vv) }
        when Date, Time then v.iso8601
        when OpenStruct
          v.to_h.select { |k, _v| !%i[_parent _unsupported_types].include?(k) }
        else v
        end
      end
    end
  end
end
