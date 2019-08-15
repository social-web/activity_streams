# frozen_string_literal: true

module ActivityStreams
  class Factory
    def initialize(json)
      @json = json.freeze
    end

    def build
      hash = JSON.parse(@json)
      obj = deep_initialize(hash)
      obj.original_json = @json
      obj
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
      when 'RsaSignature2017' then Extensions::LinkedDataSignature
      else raise UnsupportedType, type
      end
    end

    def transform_values(hash)
      attrs = hash.transform_values { |v| deep_initialize(v) }
      klass = find_klass(hash['type'])

      unsupported_properties = unsupported_properties(klass, attrs)

      obj = klass.new(attrs)
      obj.unsupported_properties = unsupported_properties
      obj
    end

    def unsupported_properties(klass, attrs)
      attrs.each.with_object({}) do |(k, _v), unsupported_props|
        if !klass.attribute_types.keys.include?(k)
          unsupported_props[k] = attrs.delete(k)
        end
      end
    end
  end
end
