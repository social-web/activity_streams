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
        props.merge!(:@context => self[:@context]) if self[:@context]
        props.merge!(type: self[:type]) if self[:type]
        props.merge!(id: self[:id]) if self[:id]
        props.merge!(_unsupported_properties) unless _unsupported_properties.empty?
        props.transform_keys! { |k| k.to_sym }
        props = self.is_a?(ActivityStreams::Activity::Update) ? props : props.compact

        # Avoid infinite loops caused by circles in nested properties
        compress!

        ActivityStreams::Utilities::Queue.new.call(props, depth: 1) do |prps|
          next unless prps.is_a?(Hash)

          queued_up = []

          prps.transform_values! do |v|
            case v
            when ActivityStreams::Model then v.properties
            when Array then v.map { |i| i.to_json }
            when Date, Time then v.iso8601
            when OpenStruct then v.to_h
            else v
            end
          end

          queued_up
        end
      end
    end
  end
end
