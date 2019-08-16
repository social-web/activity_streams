# frozen_string_literal: true

require_relative 'object'

module ActivityStreams
  class Actor < ActivityStreams::Object; end
end

Dir[File.join(__dir__, 'actor', '*.rb')].each { |f| require f }
