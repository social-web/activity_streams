# frozen_string_literal: true

module ActivityStreams
  module Concerns
    module Identity
      def ==(obj)
        case obj
        when ActivityStreams::Model then obj.id == self[:id]
        when Hash then [obj['id'], obj[:id]].include?(self[:id])
        else false
        end
      end

      def inspect
        props = properties.map do |prop, val|
          prop = %(@#{prop})
          val = val.is_a?(self.class) ? val.id : val
          %(#{prop}=#{val.inspect || 'nil'})
        end
        %(#<#{self.class.name} #{props.join(' ')}>)
      end

      def is_a?(klass)
        their_type = ActivityStreams.types.invert[klass]
        [their_type, type, ActivityStreams, ActivityStreams::Object].include?(klass)
      end
    end
  end
end
