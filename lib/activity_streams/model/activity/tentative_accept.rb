# frozen_string_literal: true

require 'activity_streams/model/activity/accept'

module ActivityStreams
  class Activity::TentativeAccept < Activity::Accept
    ActivityStreams.register_type('TentativeAccept', self)
  end
end
