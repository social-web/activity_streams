# frozen_string_literal: true

module ActivityStreams
  class Object < ActivityStreams::Model
    ActivityStreams.register_type('Object', self)
    %i[
      attachment attributedTo audience
      bcc bto
      cc content context
      duration
      generator
      icon image inReplyTo
      location
      mediaType
      name nameMap
      preview
      replies
      summary
      tag
      url
      to
    ].each(&method(:property))

    property :published, type: PropertyTypes::DateTime
    property :startTime, type: PropertyTypes::DateTime
    property :endTime, type: PropertyTypes::DateTime
    property :updated, type: PropertyTypes::DateTime

    def is_a?(klass)
      if klass == ActivityStreams::Object
        self.class.ancestors.include?(klass)
      else
        super
      end
    end
  end
end

Dir[File.join(__dir__, 'object', '*.rb')].each { |f| require f }
