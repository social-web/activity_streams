# frozen_string_literal: true

require 'ostruct'

module ActivityStreams
  class Factory
    def initialize(json)
      @json = json.dup.freeze
    end

    def build
      hash = JSON.parse(@json)
      @context = hash.delete('@context') || ActivityStreams::NAMESPACE

      unless hash['type']
        raise ActivityStreams::Error.new('ActivityStreams require a "type" property')
      end

      obj = from_hash(hash)
      raise ActivityStreams::UnsupportedType.new(@json) if obj.nil?

      obj.context = @context
      obj._original_json = @json
      obj
    rescue JSON::ParserError => e
      raise Error, e.message
    end

    private

    def from_hash(hash)
      obj = build_model(hash)

      ActivityStreams::Utilities::Queue.new.call(obj) do |o|
        queued_up = []

        o.to_h.each do |prop, v|
          case v
          when Hash
            queued_up << child = build_model(v)
            o[prop] = child
            child._parent = o if child.is_a?(ActivityStreams)
          end
        end

        queued_up
      end

      obj
    end

    def build_model(hash)
      return OpenStruct.new(hash) unless hash['type']

      klass = ActivityStreams.types_registry[hash['type']]
      return OpenStruct.new(hash) unless klass

      obj = klass.new

      load_context(@context, obj)
      obj.properties = hash

      obj._unsupported_properties = unsupported_properties(klass, hash)
      obj
    end

    def load_context(ctx, obj)
      case ctx
      when Array then ctx.each { |c| load_context(c, obj) }
      when Hash then ctx.each_value { |c| load_context(c, obj) }
      when String then obj._load_extension(ctx)
      when NilClass then raise TypeError
      end
    end

    def unsupported_properties(klass, props)
      props.each.with_object({}) do |(k, _v), unsupported_props|
        if !klass.properties.include?(k.to_sym)
          unsupported_props[k] = props.delete(k)
        end
      end
    end
  end
end
