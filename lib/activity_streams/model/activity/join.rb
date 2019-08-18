# frozen_string_literal: true

module ActivityStreams
  class Activity::Join < Activity
    ActivityStreams.register_type('Join', self)
  end
end
