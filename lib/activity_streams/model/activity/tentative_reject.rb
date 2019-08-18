# frozen_string_literal: true

require 'activity_streams/model/activity/reject'

module ActivityStreams
  class Activity::TentativeReject < Activity::Reject
    ActivityStreams.register_type('TentativeReject', self)
  end
end
