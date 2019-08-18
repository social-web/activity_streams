# frozen_string_literal: true

module ActivityStreams
  class Activity::Announce < Activity
    ActivityStreams.register_type('Announce', self)
  end
end
