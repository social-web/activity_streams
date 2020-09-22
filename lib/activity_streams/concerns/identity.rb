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
      alias_method :===, :==

      def inspect
        props = properties.select { |k, _v| !%i[@context id type].include?(k) }.map do |prop, val|
          prop = %(@#{prop})
          val = val.is_a?(ActivityStreams::Object) ?
            %(#<ActivityStreams::#{val[:type]} @id="#{val[:id]}">) :
            val

          %(#{prop}=#{val.inspect || 'nil'})
        end

        %(#<ActivityStreams::#{self[:type]} @context=#{self[:@context]} @id=#{self[:id] || 'nil'} #{props.join(' ')}>)
      end

      def is_a?(klass)
        [self.class, ActivityStreams, ActivityStreams::Object].include?(klass)
      end
    end
  end
end
