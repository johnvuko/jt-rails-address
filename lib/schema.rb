module JT::Rails::Address::Schema

	COLUMNS = {
		formatted_address: :string,
		street_number: :string,
		street_name: :string,
		street: :string,
		city: :string,
		zip_code: :string,
		department: :string,
		department_code: :string,
		state: :string,
		state_code: :string,
		country: :string,
		country_code: :string,
		lat: :float,
		lng: :float,
	}

	module Statements
		def add_address(table_name, *arguments)
			raise ArgumentError, "Please specify name in your add_address call in your migration." if arguments.empty?

			arguments.each do |prefix|
				COLUMNS.each_pair do |column_name, column_type|
					add_column(table_name, "#{prefix}_#{column_name}", column_type)
				end
			end
		end

		def remove_address(table_name, *arguments)
			raise ArgumentError, "Please specify name in your remove_address call in your migration." if arguments.empty?

			arguments.each do |prefix|
				COLUMNS.each_pair do |column_name, column_type|
					remove_column(table_name, "#{prefix}_#{column_name}", column_type)
				end
			end
		end
	end

	module TableDefinition
		def address(*arguments)
			raise ArgumentError, "Please specify name in your address call in your migration." if arguments.empty?

			arguments.each do |prefix|
				COLUMNS.each_pair do |column_name, column_type|
					column("#{prefix}_#{column_name}", column_type)
				end
			end
		end
	end

end