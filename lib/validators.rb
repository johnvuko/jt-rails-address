module JT::Rails::Address::Validators
	
	extend ActiveSupport::Concern

	included do |base|
		
		before_validation :check_if_reset_address

		base.class_eval do

			# jt_rails_address_fields is shared only by a class and its subclass
			def self.jt_rails_address_fields
				class_variable_set(:@@jt_rails_address_fields, []) if !class_variable_defined?(:@@jt_rails_address_fields)
				class_variable_get(:@@jt_rails_address_fields)
			end

		end
	end

	class_methods do

		def has_address(prefix, options = {})
			attr_accessor prefix
			attr_accessor "#{prefix.to_s}_destroy"

			jt_rails_address_fields << prefix.to_sym

			define_singleton_method("#{prefix}_fields") do
				fields = []
				for field in JT::Rails::Address.fields
					fields << "#{prefix}_#{field}".to_sym
				end
				fields
			end
		end

	end

	def check_if_reset_address
		for address_field in self.class.jt_rails_address_fields
			if ActiveRecord::Type::Boolean.new.cast(self.send("#{address_field}_destroy"))
				reset_address(address_field)
			end
		end
	end

	def reset_address(prefix)
		for field in JT::Rails::Address.fields
			self["#{prefix}_#{field}"] = nil
		end
	end

	def load_address(prefix, data)
		reset_address(prefix)

		for key, value in data
			self["#{prefix}_#{key}"] = value
		end
	end

end
