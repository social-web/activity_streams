# frozen_string_literal: true

require 'activity_streams/objects/activity/offer'

module ActivityStreams
  class Activity::Invite < Activity::Offer
    ActivityStreams.register_type('Invite', self)
  end
end
