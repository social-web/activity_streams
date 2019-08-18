# frozen_string_literal: true

module ActivityStreams
  class Activity::Read < Activity
    ActivityStreams.register_type('Read', self)
  end
end
