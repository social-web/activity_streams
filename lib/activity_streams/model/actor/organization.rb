# frozen_string_literal: true

module ActivityStreams
  class Actor::Organization < Actor
    ActivityStreams.register_type('Organization', self)
  end
end
