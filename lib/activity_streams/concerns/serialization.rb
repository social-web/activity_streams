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
        initial = to_h
        count = 0
        result = Utilities::Queue.new.call(initial, depth: 10) do |child|
          count += 1

          if count != 10
            child.transform_values! { |v| convert_to_json(v) }
          else
            # When we reach depth, convert the ActivityStreams objects to their ID strings.
            child.transform_values! do |v|
              case v
              when ActivityStreams then v[:id]
              when Hash then v.transform_values! do |vv|
                case vv
                when ActivityStreams then v[:id]
                else vv
                end
              end
              else convert_to_json(v)
              end
            end
          end
        end

        result.to_json
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
