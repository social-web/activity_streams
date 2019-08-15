# frozen_string_literal: true

module ActivityStreams
  # {
  #   "@context": [
  #     "https://www.w3.org/ns/activitystreams",
  #     {
  #       "ostatus": "http://ostatus.org#",
  #       "atomUri": "ostatus:atomUri",
  #       "inReplyToAtomUri": "ostatus:inReplyToAtomUri",
  #       "conversation": "ostatus:conversation",
  #       "sensitive": "as:sensitive",
  #       "Hashtag": "as:Hashtag",
  #       "toot": "http://joinmastodon.org/ns#",
  #       "Emoji": "toot:Emoji",
  #       "focalPoint": {
  #         "@container": "@list",
  #         "@id": "toot:focalPoint"
  #       },
  #       "blurhash": "toot:blurhash"
  #     }
  #   ],
  #   "id": "https://ruby.social/users/shanecav/statuses/102570231917342996/activity",
  #   "type": "Create",
  #   "actor": "https://ruby.social/users/shanecav",
  #   "published": "2019-08-06T13:18:52Z",
  #   "to": [
  #     "https://www.w3.org/ns/activitystreams#Public"
  #   ],
  #   "cc": [
  #     "https://ruby.social/users/shanecav/followers"
  #   ],
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
  #   },
  #   "signature": {
  #     "type": "RsaSignature2017",
  #     "creator": "https://ruby.social/users/shanecav#main-key",
  #     "created": "2019-08-06T13:18:53Z",
  #     "signatureValue": "Y6wqiUgqm/ykzKw/jCtsB5fQciGq9TMILNt57FanVg5N8UfLg4vG7Z9Xg6jIAMb++UzyDCW2oc3k9OzD/w0iCSsbMG3Mi+0OdVXNEK7DarDMWJHLgOTaUMW7C/hY8Z+OlhbSu+VvhRVuFUETgTxCDxnGSydZyFL8PTjNQ52hbEbkDqKyS+SwyQqr4T4niM5c631cwlVfX8cwSPWKdNjEpQGyqSp4nqxfw//Mtz4n6eK4X0FcZVoGA8ZddZXViZB/xw0SZfxj+ctKqz2BHRtn7f3MNMlkIBdhuqbIy46DfTODQFnnbHsuLykR8uXL7d1nf27sEdczxzcWRgnK8dG+aQ=="
  #   }
  # }
  class Activity::Create < Activity; end
end
