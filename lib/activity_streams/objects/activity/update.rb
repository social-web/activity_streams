# frozen_string_literal: true

module ActivityStreams
  class Activity::Update < Activity
    ActivityStreams.register_type('Update', self)
  end
end
