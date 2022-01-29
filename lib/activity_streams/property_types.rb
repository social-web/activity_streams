# frozen_string_literal: true

module ActivityStreams
  module PropertyTypes
    class InvalidType < ActivityStreams::Error; end

    # https://tools.ietf.org/html/rfc3986#page-50
    IRI_REGEX = %r{^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)(\?([^#]*))?(#(.*))?}.freeze

    class Any
      def self.===(other)
        true
      end
    end

    class Boolean
      def self.===(other)
        other == TrueClass || other == FalseClass
      end
    end

    class DateTime
      def self.===(other)
        other == self ||
          other.is_a?(::DateTime) ||
          other.is_a?(::Time) ||
          (other.is_a?(::String) && ::Time.iso8601(other))
      rescue
        raise InvalidType
      end
    end

    class IRI
      def self.===(other)
        other == self ||
          (other.is_a?(String) && other.match?(IRI_REGEX))
      end
    end

    class Link
      def self.===(other)

      end
    end

    class Object
      def self.===(other)
        other == ActivityStreams::Objects
      end
    end

    class String
      def self.===(other)
        other.is_a?(String)
      end
    end
  end
end
