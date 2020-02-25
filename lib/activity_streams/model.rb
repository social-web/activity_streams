# frozen_string_literal: true


Dir[File.join(__dir__, 'concerns', '*.rb')].each { |f| require f }
Dir[File.join(__dir__, 'validators', '*.rb')].each { |f| require f }

module ActivityStreams
  def self.contexts
    @contexts ||= {}
  end

  def self.new(**props)
    if props[:type]
      types_registry[props[:type]].new(**props)
    else
      self.object(**props)
    end
  end

  def self.register_context(ctx, mod)
    contexts[ctx] = mod
  end

  def self.types_registry
    @types ||= {}
  end

  def self.register_type(type, klass)
    types_registry[type.to_s] = klass

    method_name = type.to_s.gsub(/([A-Za-z\d]+)([A-Z][a-z])/,'\1_\2').downcase
    define_singleton_method method_name do |**props, &blk|
      if blk
        instance = klass.new
        instance.instance_exec(&blk)
        instance
      else
        klass.new(**props)
      end
    end

    klass
  end

  class Model
    include Concerns::Identity
    include Concerns::Properties
    include Concerns::Serialization

    property :@context, type: PropertyTypes::Any
    property :id, type: PropertyTypes::IRI
    property :type, type: PropertyTypes::Any

    attr_accessor :_original_json
    attr_accessor :_parent

    def initialize(**props)
      self[:@context] = 'https://www.w3.org/ns/activitystreams'

      self[:id] = self[:type] = nil
      self.merge_properties(props) if props

      unless properties[:type]
        properties[:type] = ActivityStreams.types_registry.invert[self.class]
      end

    end

    def compress
      compressed_props = {}
      self.traverse_properties(depth: 1) do |hash|
        parent, child, prop = hash.values_at(:parent, :child, :property)
        if child.is_a?(ActivityStreams::Object)
          compressed_props[prop] = child[:id]
        else
          compressed_props[prop] = child
        end
      end
      self.class.new(**compressed_props)
    end

    def context(arg = nil)
      if arg
        self[:@context] = arg
      else
        _parent&[:@contact] || self[:@context]
      end
    end

    def context=(ctx)
      unless _parent
        case self[:@context]
        when NilClass then self[:@context] = ctx
        when Array then self[:@context] |= ctx
        when String then self[:@context] += Array(self[:@context]) + Array(ctx)
        end

        self[:@context].tap do |ctx_prop|
          if ctx_prop.is_a?(Array)
            ctx_prop.uniq!
            ctx_prop.compact!
            ctx_prop.each { |ctx| _load_extension(ctx) }
            ctx_prop.one? ? ctx_prop.first : ctx_prop
          else
            _load_extension(ctx_prop)
          end
        end

        self[:@context]
      end
    end

    def initialize_copy(other)
      new_props = other.properties

      Utilities::Queue.new.call(new_props) do |child|
        queued_up = []

        child.each do |k, v|
          case v
          when ActivityStreams
            child_props = v.properties
            queued_up << child_props
            child[k] = ActivityStreams.new(**child_props)
          when Array
            queued_up += v.select { |vv| vv.is_a?(Hash) || vv.is_a?(ActivityStreams) }
          when Hash then queued_up << v
          else child[k] = v.dup
          end
        end

        queued_up
      end

      ActivityStreams.new(**new_props)
    end

    def _parent=(v)
      self.instance_eval('undef :context=') if respond_to?(:context=)
      remove_instance_variable(:@context) if @context
      properties.delete(:@context)
      _unsupported_properties.delete('@context')
      @_parent = v
    end

    def _load_extension(ctx)
      mod = ActivityStreams.contexts[ctx]
      self.singleton_class.extend(mod) if mod
    end

    def type(arg = nil)
      arg ? @type = arg : @type
    end

    def type=(v)
      @type = v.freeze
    end
  end
end

Dir[File.join(__dir__, 'extensions', '**', '*.rb')].each { |f| require f }
require_relative './objects/object'
require_relative './objects/activity'
require_relative './objects/actor'
require_relative './objects/collection'
require_relative './objects/link'
