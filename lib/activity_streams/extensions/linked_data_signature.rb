# frozen_string_literal: true

module ActivityStreams
  module Extensions
    class LinkedDataSignature < ::ActivityStreams::Model
      %w[
        created creator
        domain
        nonce
        signatureValue
        type
      ].each(&method(:attribute))
      SIGNATURE_SUITES = %w[RsaSignature2017].freeze

      attribute :created, :time

      validates :created, presence: true
      validates :creator, presence: true
      validates :signatureValue, presence: true
      validates :type, presence: true, inclusion: { in: SIGNATURE_SUITES }
    end
  end
end
