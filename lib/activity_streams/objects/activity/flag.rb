# frozen_string_literal: true

module ActivityStreams
  class Activity::Flag < Activity
    ActivityStreams.register_type('Flag', self)
  end
end
