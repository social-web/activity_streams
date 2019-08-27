# frozen_string_literal: true

module ActivityStreams
  class Factory
    def initialize(json)
      @json = json.dup.freeze

    end

    def build
      hash = JSON.parse(@json)
      raise ActivityStreams::Error unless hash['@context'] && hash['type']

      @context = hash.delete('@context')
      obj = deep_initialize(hash)
      raise ActivityStreams::UnsupportedType.new(@json) if obj.nil?

      obj._context = @context
      obj._original_json = @json
      obj
    rescue JSON::ParserError => e
      raise Error, e.message
    end

    private

    def deep_initialize(object, parent = nil)
      case object
      when Hash then object['type'] ? transform_values(object, parent) : object
      when Array then object.map { |o| deep_initialize(o, parent) }
      else object
      end
    end

    def load_context(ctx, obj)
      case ctx
      when Array then ctx.each { |c| load_context(c, obj) }
      when Hash then ctx.each_value { |c| load_context(c, obj) }
      when String then
        mod = ActivityStreams.contexts[ctx]
        obj.load_extension(mod) if mod
      when NilClass then raise TypeError
      end
    end

    def transform_values(hash, parent = nil)
      klass = ActivityStreams.types[hash['type']]
      return if klass.nil?

      obj = klass.new
      props = hash.transform_values { |v| deep_initialize(v, obj) }

      load_context(@context, obj)
      obj.properties = props
      obj._parent = parent if parent

      obj._unsupported_properties = unsupported_properties(klass, props)
      obj
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
