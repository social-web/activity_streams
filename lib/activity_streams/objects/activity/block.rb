# frozen_string_literal: true

require 'activity_streams/objects/activity/ignore'

module ActivityStreams
  class Activity::Block < Activity::Ignore
    ActivityStreams.register_type('Block', self)
  end
end
