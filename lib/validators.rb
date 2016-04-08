module JT::Rails::Address::Validators
	
	extend ActiveSupport::Concern

	class_methods do

		def has_address(prefix, options = {})
			attr_accessor prefix

			define_singleton_method("#{prefix}_fields") do
				fields = []
				for field in JT::Rails::Address.fields
					fields << "#{prefix}_#{field}".to_sym
				end
				fields
			end
		end

	end

	def load_address(prefix, data)
		# Reset fields
		for field in JT::Rails::Address.fields
			self["#{prefix}_#{field}"] = nil
		end

		for key, value in data
			self["#{prefix}_#{key}"] = value
		end
	end

end
