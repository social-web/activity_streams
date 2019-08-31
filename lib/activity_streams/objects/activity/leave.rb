# frozen_string_literal: true

module ActivityStreams
  class Activity::Leave < Activity
    ActivityStreams.register_type('Leave', self)
  end
end
