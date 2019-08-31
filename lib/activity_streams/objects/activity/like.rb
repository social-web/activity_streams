# frozen_string_literal: true

module ActivityStreams
  class Activity::Like < Activity
    ActivityStreams.register_type('Like', self)
  end
end
