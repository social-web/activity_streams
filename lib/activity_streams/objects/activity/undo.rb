# frozen_string_literal: true

module ActivityStreams
  class Activity::Undo < Activity
    ActivityStreams.register_type('Undo', self)
  end
end
