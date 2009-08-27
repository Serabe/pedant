module Pedant
  class TypeError < StandardError; end
  class GuardError < StandardError; end
  
  module Dummy

    def self.included(base)
      base.extend ClassMethods
      Class.extend ClassMethods
    end

    def self.extended(base)
      base.extend ClassMethods
      Class.extend ClassMethods
    end

    module ClassMethods; def returns(*args, &block); end; end
  end
  
  module Returns

    def self.included(base)
      base.extend ClassMethods
      Class.extend ClassMethods
    end

    def self.extended(base)
      base.extend ClassMethods
      Class.extend ClassMethods
    end

    module ClassMethods

      def returns(sym, *klasses, &block)
        old_method = instance_method(sym)
        self.send(:define_method, sym) do |*args|
	  ret = old_method.bind(self).call(*args)
        
          # Type check
          unless klasses.empty? or klasses.any?{|klass| ret.is_a?(klass) }
            raise Pedant::TypeError, "Bad return value! Got #{ret.inspect}, " \
	      "expected instance of #{klasses.inspect}."
	  end
        
	  # User-defined guard
          unless block.nil? or block.call(ret)
            raise Pedant::GuardError, "Did not pass user-defined guard."
          end

	  ret
	end
      end
    end
  end
end
