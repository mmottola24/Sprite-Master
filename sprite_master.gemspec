Gem::Specification.new do |s|
  s.name        = 'sprite_master'
  s.version     = '0.0.0'
  s.date        = '2012-04-10'
  s.summary     = 'SpriteMaster FTW!'
  s.description = 'Builds css and docs for sprite sheet'
  s.authors     = ['Michael Mottola', 'Nickolas Kenyeres']
  s.email       = 'mikemottola@gmail.com'
  s.files       = ['lib/sprite_master.rb']
  s.executables << 'sprite_master'
  s.homepage    = 'http://rubygems.org/gems/sprite_master'

  s.required_rubygems_version = ">= 1.3.6"

  # gem dependencies
  s.add_dependency("xml-simple", ">= 1.1.0")

end