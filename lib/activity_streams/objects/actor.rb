# frozen_string_literal: true

require_relative 'object'

module ActivityStreams
  class Actor < ActivityStreams::Object
    ActivityStreams.register_type('Actor', self)

    def is_a?(klass)
      if klass == ActivityStreams::Actor
        self.class.ancestors.include?(klass)
      else
        super
      end
    end
  end
end

Dir[File.join(__dir__, 'actor', '*.rb')].each { |f| require f }
