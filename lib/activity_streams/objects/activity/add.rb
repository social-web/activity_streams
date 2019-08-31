# frozen_string_literal: true

module ActivityStreams
  class Activity::Add < Activity
    ActivityStreams.register_type('Add', self)
  end
end
