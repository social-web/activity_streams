# frozen_string_literal: true

module ActivityStreams
  class Object < ActivityStreams::Model
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

    property :published, Types::Params::Time
    property :startTime, Types::Params::Time
    property :updated, Types::Params::Time
  end
end

Dir[File.join(__dir__, 'object', '*.rb')].each { |f| require f }
