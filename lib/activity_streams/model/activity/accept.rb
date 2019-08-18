# frozen_string_literal: true

module ActivityStreams
  class Activity::Accept < Activity
    ActivityStreams.register_type('Accept', self)
  end
end
