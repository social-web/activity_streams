# frozen_string_literal: true

module ActivityStreams
  module Validators
    ContextValidator = lambda do |obj|
      ctx = obj._context
      return if ctx.nil? ||
        (ctx.is_a?(Array) && ctx.include?(Model::CONTEXT)) ||
        (ctx.is_a?(String) && ctx == Model::CONTEXT)

      obj.errors.add(
        :'@context',
        "@context is unsupported. Must be #{Model::CONTEXT}, got #{ctx}"
      )
    end
  end
end
