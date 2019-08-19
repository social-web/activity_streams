# frozen_string_literal: true

require 'activity_streams/model/activity/intransivite_activity'

module ActivityStreams
  class Activity::Arrive < Activity::IntransitiveActivity
    ActivityStreams.register_type('Arrive', self)
  end
end
