Gem::Specification.new do |s|
	s.name = 'jt-rails-address'
	s.summary = "Postal addresses management in Ruby On Rails and Javascript"
	s.description = "JTRailsAddress simplify postal addresses management and geocoding with Google Maps in Ruby On Rails and Javascript."
	s.homepage = 'https://github.com/jonathantribouharet/jt-rails-address'
	s.version = '1.1.1'
	s.files = `git ls-files`.split("\n")
	s.require_paths = ['lib']
	s.authors = ['Jonathan TRIBOUHARET']
	s.email = 'jonathan.tribouharet@gmail.com'
	s.license = 'MIT'
	s.platform = Gem::Platform::RUBY

	s.add_dependency('graticule', '> 2.0')
end
