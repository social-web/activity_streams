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
          queue += Array(result)
          loop_count += 1
        end
        initial
      end
    end
  end
end
