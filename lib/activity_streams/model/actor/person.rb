# frozen_string_literal: true

module ActivityStreams
  class Actor::Person < Actor
    ActivityStreams.register_type('Person', self)
  end
end
