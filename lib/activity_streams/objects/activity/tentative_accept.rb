# frozen_string_literal: true

require 'activity_streams/objects/activity/accept'

module ActivityStreams
  class Activity::TentativeAccept < Activity::Accept
    ActivityStreams.register_type('TentativeAccept', self)
  end
end
