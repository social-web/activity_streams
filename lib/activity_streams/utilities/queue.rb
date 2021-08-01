# frozen_string_literal: true

module ActivityStreams
  module Utilities
    class Queue
      def call(initial, depth: Float::INFINITY)
        queue = [initial]
        loop_count = 0
        while !queue.empty? && loop_count <= depth do
          nxt = queue.shift
          result = yield nxt

          # The Array() function will put `result` into an array or leave it as is if it's already an array. For a Hash,
          # it will convert the hash to an array of an arrays of keys and values. We just want result in an array.
          queue += result.is_a?(Hash) ? [result] : Array(result)

          loop_count += 1
        end
        initial
      end
    end
  end
end
