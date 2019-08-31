# frozen_string_literal: true

module ActivityStreams
  class Activity::View < Activity
    ActivityStreams.register_type('View', self)
  end
end
