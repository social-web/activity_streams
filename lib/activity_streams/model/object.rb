# frozen_string_literal: true

module ActivityStreams
  class Object < ActivityStreams::Model
    ActivityStreams.register_type('Link', self)
    %i[
      attachment attributedTo audience
      bcc bto
      cc content context
      duration
      endTime
      generator
      icon id image inReplyTo
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

    property :published, PropertyTypes::Params::Time
    property :startTime, PropertyTypes::Params::Time
    property :updated, PropertyTypes::Params::Time
  end
end

Dir[File.join(__dir__, 'object', '*.rb')].each { |f| require f }
