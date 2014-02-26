# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "chef-ab"
  s.version     = '0.2.0'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Grégoire Seux"]
  s.license     = "Apache License v2"
  s.summary     = %q{AB test like chef conf deployement}
  s.homepage    = "http://github.com/kamaradclimber/chef-ab"
  s.description = %q{}
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  s.add_dependency 'ipaddress'
  s.add_dependency 'backports' #this is required for ruby 1.9.3

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'coveralls'
end
