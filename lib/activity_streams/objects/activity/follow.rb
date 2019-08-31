# frozen_string_literal: true

module ActivityStreams
  class Activity::Follow < Activity
    ActivityStreams.register_type('Follow', self)
  end
end
