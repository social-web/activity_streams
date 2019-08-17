# frozen_string_literal: true

require 'dry-types'

module ActivityStreams
  module PropertyTypes
    class InvalidType < ActivityStreams::Error; end

    include Dry::Types()
  end
end
