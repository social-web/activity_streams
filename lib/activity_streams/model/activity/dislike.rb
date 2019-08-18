# frozen_string_literal: true

module ActivityStreams
  class Activity::Dislike < Activity
    ActivityStreams.register_type('Dislike', self)
  end
end
