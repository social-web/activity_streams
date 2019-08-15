# frozen_string_literal: true

module ActivityStreams
  class Activity::Delete < Activity
    # {
    #   "@context": [
    #     "https://www.w3.org/ns/activitystreams",
    #     {
    #       "ostatus": "http://ostatus.org#",
    #       "atomUri": "ostatus:atomUri"
    #     }
    #   ],
    #   "id": "https://ruby.social/users/shanecav/statuses/102570231917342996#delete",
    #   "type": "Delete",
    #   "actor": "https://ruby.social/users/shanecav",
    #   "to": [
    #     "https://www.w3.org/ns/activitystreams#Public"
    #   ],
    #   "object": {
    #     "id": "https://ruby.social/users/shanecav/statuses/102570231917342996",
    #     "type": "Tombstone",
    #     "atomUri": "https://ruby.social/users/shanecav/statuses/102570231917342996"
    #   },
    #   "signature": {
    #     "type": "RsaSignature2017",
    #     "creator": "https://ruby.social/users/shanecav#main-key",
    #     "created": "2019-08-06T13:18:57Z",
    #     "signatureValue": "FwTuT1BG5zf10hl+YCUtP3uhTWhdwSUUTiXWv2yCXPCpy1EpK1ZDQuWvCSZJvWoNbc2A+51WHKcuUod/0/ln0IpDewS2dhgeMyQ7r2VVN0ky7WDSWzdoEkLueyXweNKGuIQNNAfcPAPTelSIqeREa06Ssbf3VnP3urOiFBLN55VUI5hFhF3uM18Pfx7pww6+E0/fDulNCqAkw7iWRouOyXDZZNEvTz5u+bBpR37DQCr7ZvePADBhpzYWLcjS8Jvv3wOrkAG9No1ZgcVpeWqOLK6zCQPShbaUCqV1MzdAVTb553riQ8fldzYmd4dT8U4nkM96GMJIUA9rv8i5C45NhA=="
    #   }
    # }
  end
end
