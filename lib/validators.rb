module JT::Rails::Address::Validators
	
	extend ActiveSupport::Concern

	class_methods do

		def has_address(prefix, options = {})
			attr_accessor prefix
		end

	end

	def load_address(prefix, data)
		for field in JT::Rails::Address.fields
			self["#{prefix}_#{field}"] = nil
		end

		for key, value in data
			self["#{prefix}_#{key}"] = value
		end
	end

end
