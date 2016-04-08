# JTRailsAddress

[![Gem Version](https://badge.fury.io/rb/jt-rails-address.svg)](http://badge.fury.io/rb/jt-rails-address)

JTRailsAddress simplify postal addresses management and geocoding with Google Maps API in Ruby On Rails and Javascript.

## Installation

JTRailsAddress is distributed as a gem, which is how it should be used in your app.

Include the gem in your Gemfile:

    gem 'jt-rails-address', '~> 1.0'

## Usage

### Basic usage

In your migration file:

```ruby
class CreateUsers < ActiveRecord::Migration
	def change
		create_table :users do |t|

			t.string :username, null: false
			t.string :email, null: false
			t.string :password_digest

			# Each field will be prefixed by 'address_'
			t.address :address

			t.timestamps null: false
		end
	end
end
```

It will create all the fields you need for address management:

- `formatted_address`, "Empire State Building, 350 5th Ave, New York, NY 10118"
- `street_number`, "350"
- `street_name`, "5th Ave"
- `street`, "350 5th Ave", it's a concatenation of `street_number` and `street_name`
- `city`
- `zip_code`
- `department`
- `department_code`
- `state`
- `state_code`
- `country`
- `country_code`
- `lat`, GPS latitude
- `lng`, GPS longitude

In your model:
```ruby
class User < ActiveRecord::Base

    # Add a virtual field named `address` and a class method `address_fields` returning `JT::Rails::Address.fields` prefixed by `address_` in this case
    has_address :address

end
```

### Javascript usage with Google Maps API

You probably want to use an autocompletion service like Google Maps API.

In your HTML:
```html
<!-- Basic form, address is just a virtual field used for searching the address on Google Maps API -->
<%= form_for @user do |f| %>

	<div class="jt-address-autocomplete">
		<!-- This field is used to search the address on Google Maps -->
		<%= f.text_field :address, class: 'jt-address-search' %>

		<!-- All fields are hidden because the javascript will set their value automatically -->
		<% for attr in JT::Rails::Address.fields %>
			<%= f.hidden_field "address_#{attr}", class: "jt-address-field-#{attr}" %>
		<% end %>
	</div>

	<%= f.submit %>

<% end %>

<!-- Load Google Maps and call googleMapInitialize when it's done -->
<script async type="text/javascript" src="//maps.googleapis.com/maps/api/js?libraries=places&callback=googleMapInitialize&key=YOUR_GOOGLE_API_KEY"></script>
```

In your `applicaton.js` you have to add:
```javascript
//= require jt_address

// This function is call when Google Maps is loaded
window.googleMapInitialize = function(){

    // Simple usage
    $('.jt-address-autocomplete').jt_address();
    
    // Advanced usage with google options
    $('.jt-address-autocomplete').jt_address({
        type: ['restaurant'],
        componentRestrictions: { country: 'fr' }
    });

};
```

Each time the data for the address change, an event `jt:address:data_changed` is triggered.
You can catch it with:

```javascript
$('.jt-address-autocomplete').on('jt:address:data_changed', function(event, data){
	console.log(data);
});

```

### Google Maps API in Ruby

Thanks to [graticule](https://github.com/collectiveidea/graticule), there is a simple way to use autocomplete in Ruby.

```ruby
# Simple usage
data = JT::Rails::Address.search("Eiffel Tower", "YOUR GOOGLE API KEY")

# Advanced usage
data = JT::Rails::Address.search("Eiffel Tower", "YOUR GOOGLE API KEY", {components: 'country:fr'})

# Use the data retrieve from Google Maps API
my_instance.load_address(:address, data)
```

## Author

- [Jonathan Tribouharet](https://github.com/jonathantribouharet) ([@johntribouharet](https://twitter.com/johntribouharet))

## License

JTRailsAddress is released under the MIT license. See the LICENSE file for more info.
