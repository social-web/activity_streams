# frozen_string_literal: true

require 'activity_streams/objects/activity/intransivite_activity'

module ActivityStreams
  class Activity::Travel < Activity::IntransitiveActivity
    ActivityStreams.register_type('Travel', self)
  end
end
