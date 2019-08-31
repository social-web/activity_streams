# frozen_string_literal: true

require_relative 'object'

module ActivityStreams
  class Collection < ActivityStreams::Object
    ActivityStreams.register_type('Collection', self)
    %i[current first items last totalItems].each(&method(:property))
  end
end

Dir[File.join(__dir__, 'collection', '*.rb')].each { |f| require f }
