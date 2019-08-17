# frozen_string_literal: true

module ActivityStreams
  class Activity < ActivityStreams::Object
    %w[
      actor
      instrument
      object origin
      result
      target
    ].each(&method(:property))
  end
end

Dir[File.join(__dir__, 'activity', '*.rb')].each { |f| require f }
