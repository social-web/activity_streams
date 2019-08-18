# frozen_string_literal: true

module ActivityStreams
  class Actor::Group < Actor
    ActivityStreams.register_type('Group', self)
  end
end
