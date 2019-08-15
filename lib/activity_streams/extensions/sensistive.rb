# frozen_string_literal: true

module ActivityStreams
  module Extensions
    module Sensitive
      def self.included(base)
        base.class_eval do
          attribute :sensitive, :boolean
          validates :sensitive,
            inclusion: { in: [true, false], allow_nil: true }
        end
      end
    end
  end
end
