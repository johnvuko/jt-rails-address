module JT
	module Rails
		module Address
		end
	end
end

require 'graticule'
require 'schema'
require 'validators'

module JT::Rails::Address

	module Rails
		class Engine < ::Rails::Engine
			# Get rails to add app, lib, vendor to load path
		end
	end

	class Railtie < ::Rails::Railtie
		initializer 'jt_rails_addresses.insert_into_active_record' do |app|
			ActiveSupport.on_load :active_record do
				ActiveRecord::ConnectionAdapters::Table.send :include, JT::Rails::Address::Schema::TableDefinition
				ActiveRecord::ConnectionAdapters::TableDefinition.send :include, JT::Rails::Address::Schema::TableDefinition
				ActiveRecord::ConnectionAdapters::AbstractAdapter.send :include, JT::Rails::Address::Schema::Statements

				ActiveRecord::Base.send :include, JT::Rails::Address::Validators
			end
		end
	end

	def self.fields
		JT::Rails::Address::Schema::COLUMNS.keys
	end

	def self.search(text, google_api_key, options = {})
		geocoder = Graticule.service(:google).new(google_api_key)

		begin
			request_params = options.merge({ address: text })
			response = geocoder.send('make_url', request_params).open('User-Agent' => Graticule::Geocoder::Base::USER_AGENT).read
			json = JSON.parse(response)

			return nil if !json['results'] || json['results'].size == 0

			place = json['results'][0]

			data = {}
			data['lat'] = place['geometry']['location']['lat']
			data['lng'] = place['geometry']['location']['lng']

			data['formatted_address'] = place['formatted_address']

			for address_component in place['address_components']

				if address_component['types'][0] == 'street_number'
					data['street_number'] = address_component['long_name']
				elsif address_component['types'][0] == 'route'
					data['street_name'] = address_component['long_name']
				elsif address_component['types'][0] == 'country'
					data['country'] = address_component['long_name']
					data['country_code'] = address_component['short_name']
				elsif address_component['types'][0] == 'administrative_area_level_1'
					data['state'] = address_component['long_name']
					data['state_code'] = address_component['short_name']
				elsif address_component['types'][0] == 'administrative_area_level_2'
					data['department'] = address_component['long_name']
					data['department_code'] = address_component['short_name']
				elsif address_component['types'][0] == 'locality' || address_component['types'][0] == 'administrative_area3'
					data['city'] = address_component['long_name']
				elsif address_component['types'][0] == 'postal_code'
					data['zip_code'] = address_component['long_name']
				end

			end

		   if !data['street_name'].blank?
                if !data['street_number'].blank?
                    data['street'] = "#{data['street_number']} #{data['street_name']}"
                else
                    data['street'] = data['street_name']
                end
            end

			return data
		rescue Exception => e
			STDERR.puts e.message
		end

		return nil
	end

end