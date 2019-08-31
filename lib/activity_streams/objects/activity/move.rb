# frozen_string_literal: true

module ActivityStreams
  class Activity::Move < Activity
    ActivityStreams.register_type('Move', self)
  end
end
