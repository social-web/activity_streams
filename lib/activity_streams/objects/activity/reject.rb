# frozen_string_literal: true

module ActivityStreams
  class Activity::Reject < Activity
    ActivityStreams.register_type('Reject', self)
  end
end
