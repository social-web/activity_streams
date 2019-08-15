# frozen_string_literal: true

module ActivityStreams
  module Extensions
    module WebPayments
      module Security
        def self.included(base)
          base.class_eval do
            context 'https://w3id.org/security/v1'

            attribute :id
            attribute :owner
            attribute :publicKey
            attribute :publicKeyPem
          end
        end
      end
    end
  end
end
