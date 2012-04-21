Gem::Specification.new do |s|
  s.name        = 'spritemaster'
  s.version     = '0.0.0'
  s.date        = '2012-04-10'
  s.summary     = 'SpriteMaster is a executables that generates stylesheets and supporting documentation for sprite sheets'
  s.description = 'Sprite Master is a utility to automatically generate stylesheets and supporting docs from sprite sheets generated using Zwoptex.app'
  s.authors     = ['Michael Mottola', 'Nickolas Kenyeres']
  s.email       = 'mikemottola@gmail.com'
  s.files       = ['lib/spritemaster.rb']
  s.executables << 'spritemaster'
  s.homepage    = 'http://rubygems.org/gems/sprite_master'

  s.required_rubygems_version = ">= 1.3.6"

  # gem dependencies
  s.add_dependency("xml-simple", ">= 1.1.0")

end