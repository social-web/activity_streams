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
        JSON.dump(to_h)
      end

      def to_h
        props = properties.dup
        props.merge!('@context' => @context) if @context
        props.merge!('type' => @type) if @type
        props.merge!('id' => @id) if @id
        props.merge!(_unsupported_properties) unless _unsupported_properties.empty?
        props = self.is_a?(ActivityStreams::Activity::Update) ? props : props.compact
        props.transform_values { |v| transform_values(v) }
      end

      private

      def transform_values(v)
        case v
        when ActivityStreams::Model then v.to_h
        when Array then v.map(&method(:transform_values))
        when Date, Time then v.iso8601
        when OpenStruct then transform_values(v.to_h)
        else v
        end
      end
    end
  end
end
