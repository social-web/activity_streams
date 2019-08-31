# frozen_string_literal: true

module ActivityStreams
  class Activity::Listen < Activity
    ActivityStreams.register_type('Listen', self)
  end
end
