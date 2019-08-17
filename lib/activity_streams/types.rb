# frozen_string_literal: true

require 'dry-types'

module ActivityStreams
  module Types
    class InvalidType < ActivityStreams::Error; end

    include Dry::Types()
  end
end
