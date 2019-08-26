# frozen_string_literal: true


Dir[File.join(__dir__, 'concerns', '*.rb')].each { |f| require f }
Dir[File.join(__dir__, 'validators', '*.rb')].each { |f| require f }

module ActivityStreams
  def self.contexts
    @contexts ||= {}
  end

  def self.register_context(ctx, mod)
    contexts[ctx] = mod
  end

  def self.types
    @types ||= {}
  end

  def self.register_type(type, klass)
    types[type.to_s] = klass
  end

  class Model
    require 'activity_streams/core'

    include Concerns::Properties
    include Concerns::Serialization
    extend ActivityStreams::Core

    attr_accessor :original_json
    attr_accessor :_parent

    def initialize(**props)
      props.each { |k, v| public_send("#{k}=", v) }
    end

    def load_extension(ext)
      self.singleton_class.extend(ext)
    end
  end
end

Dir[File.join(__dir__, 'extensions', '**', '*.rb')].each { |f| require f }
require_relative './model/object'
require_relative './model/activity'
require_relative './model/actor'
require_relative './model/collection'
require_relative './model/link'
