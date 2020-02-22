# frozen_string_literal: true

module ActivityStreams
  module Concerns
    module Identity
      def ==(obj)
        if obj.is_a?(ActivityStreams)
          obj[:id] == self[:id]
        else
          false
        end
      end

      def inspect
        props = properties.map do |prop, val|
          prop = %(@#{prop})
          val = val.is_a?(ActivityStreams::Object) ?
            %(#<ActivityStreams::#{val[:type]} @id="#{val[:id]}">) :
            val

          %(#{prop}=#{val.inspect || 'nil'})
        end

        %(#<ActivityStreams:#{self[:type]} #{props.join(' ')}>)
      end

      def is_a?(klass)
        their_type = ActivityStreams.types_registry.invert[klass]
        [their_type, type, ActivityStreams, ActivityStreams::Object].include?(klass)
      end
    end
  end
end
