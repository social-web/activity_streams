# frozen_string_literal: true

require_relative 'object'

module ActivityStreams
  class Collection < ActivityStreams::Object
    %w[current first items last totalItems].each(&method(:attribute))
  end
end

Dir[File.join(__dir__, 'collection', '*.rb')].each { |f| require f }
