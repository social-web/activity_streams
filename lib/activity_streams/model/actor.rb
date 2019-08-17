# frozen_string_literal: true

require_relative 'object'

module ActivityStreams
  class Actor < ActivityStreams::Object
    ActivityStreams.register_type('Actor', self)
  end
end

Dir[File.join(__dir__, 'actor', '*.rb')].each { |f| require f }
