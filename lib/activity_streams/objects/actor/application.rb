# frozen_string_literal: true

module ActivityStreams
  class Actor::Application < Actor
    ActivityStreams.register_type('Application', self)
  end
end
