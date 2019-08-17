# frozen_string_literal: true

module ActivityStreams
  module Extensions
    module Sensitive
      ActivityStreams.register_context('as:sensitive', self)

      def self.extended(base)
        base.class_eval do
          property :sensitive, PropertyTypes::Params::Bool
        end
      end
    end
  end
end
