# frozen_string_literal: true

module ActivityStreams
  class Activity::IntransitiveActivity < Activity
    ActivityStreams.register_type('IntransitiveActivity', self)

    # TODO: remove 'object' property
  end
end
