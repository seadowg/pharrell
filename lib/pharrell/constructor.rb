module Pharrell
  module Constructor
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def constructor(*args)
        Pharrell.define_contructor(self, *args)
      end
    end
  end
end
