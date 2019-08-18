# frozen_string_literal: true

require 'activity_streams/model/activity/intransivite_activity'

module ActivityStreams
  class Activity::Question < Activity::IntransitiveActivity
    ActivityStreams.register_type('Question', self)

    %i[oneOf anyOf closed].each(&method(:property))
  end
end
