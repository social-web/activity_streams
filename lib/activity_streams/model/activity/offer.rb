# frozen_string_literal: true

module ActivityStreams
  class Activity::Offer < Activity
    ActivityStreams.register_type('Offer', self)
  end
end
