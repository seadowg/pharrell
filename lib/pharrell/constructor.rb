module Pharrell
  module Constructor
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      @@constructor = []
      
      def constructor(*klasses)
        @@constructor = klasses
      end
      
      def __pharrell_constructor_classes
        @@constructor
      end
    end
  end
end
