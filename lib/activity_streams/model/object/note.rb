# frozen_string_literal: true

module ActivityStreams
  # {
  #   "object": {
  #     "id": "https://ruby.social/users/shanecav/statuses/102570231917342996",
  #     "type": "Note",
  #     "summary": null,
  #     "inReplyTo": null,
  #     "published": "2019-08-06T13:18:52Z",
  #     "url": "https://ruby.social/@shanecav/102570231917342996",
  #     "attributedTo": "https://ruby.social/users/shanecav",
  #     "to": [
  #       "https://www.w3.org/ns/activitystreams#Public"
  #     ],
  #     "cc": [
  #       "https://ruby.social/users/shanecav/followers"
  #     ],
  #     "sensitive": false,
  #     "atomUri": "https://ruby.social/users/shanecav/statuses/102570231917342996",
  #     "inReplyToAtomUri": null,
  #     "conversation": "tag:ruby.social_web,2019-08-06:objectId=1700199:objectType=Conversation",
  #     "content": "\u003cp\u003ebeep\u003c/p\u003e",
  #     "contentMap": {
  #       "en": "\u003cp\u003ebeep\u003c/p\u003e"
  #     },
  #     "attachment": [],
  #     "tag": [],
  #     "replies": {
  #       "id": "https://ruby.social/users/shanecav/statuses/102570231917342996/replies",
  #       "type": "Collection",
  #       "first": {
  #         "type": "CollectionPage",
  #         "partOf": "https://ruby.social/users/shanecav/statuses/102570231917342996/replies",
  #         "items": []
  #       }
  #     }
  #   }
  # }
  class Object::Note < Object
    ActivityStreams.register_type('Note', self)
  end
end
