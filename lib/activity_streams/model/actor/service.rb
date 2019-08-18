# frozen_string_literal: true

module ActivityStreams
  class Actor::Service < Actor
    ActivityStreams.register_type('Service', self)
  end
end
