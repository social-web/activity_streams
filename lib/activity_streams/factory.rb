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
      obj.original_json = @json
      obj
    rescue JSON::ParserError => e
      raise Error, e.message
    end

    private

    def deep_initialize(object)
      case object
      when Hash then object['type'] ? transform_values(object) : object
      when Array then object.map { |o| deep_initialize(o) }
      else object
      end
    end

    def find_klass(type)
      case type
      when 'Add' then Activity::Add
      when 'Collection' then Collection
      when 'CollectionPage' then Collection::CollectionPage
      when 'Create' then Activity::Create
      when 'Link' then Link
      when 'Note' then Object::Note
      when 'Image' then Object::Image
      when 'Person' then Actor::Person
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

    def transform_values(hash)
      klass = ActivityStreams.types[hash['type']]
      return if klass.nil?

      attrs = hash.transform_values { |v| deep_initialize(v) }

      obj = klass.new
      load_context(@context, obj)
      obj.properties = attrs

      obj._unsupported_properties = unsupported_properties(klass, attrs)
      obj
    end

    def unsupported_properties(klass, attrs)
      attrs.each.with_object({}) do |(k, _v), unsupported_props|
        if !klass.properties.include?(k)
          unsupported_props[k] = attrs.delete(k)
        end
      end
    end
  end
end
