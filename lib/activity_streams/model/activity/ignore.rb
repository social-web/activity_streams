# frozen_string_literal: true

module ActivityStreams
  class Activity::Ignore < Activity
    ActivityStreams.register_type('Ignore', self)
  end
end
