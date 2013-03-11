# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jet_fuel/version'

Gem::Specification.new do |spec|
  spec.name          = "jet_fuel"
  spec.version       = JetFuel::VERSION
  spec.authors       = ["Kareem Grant"]
  spec.email         = ["kareem@getuserwise.com"]
  spec.description   = %q{gSchool bitly clone}
  spec.summary       = %q{gSchool bitly clone}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency('rspec', '2.13.0')

  spec.add_dependency('sinatra', '1.3.5')
  spec.add_dependency('shotgun', '0.9')
  spec.add_dependency('activerecord', '3.2.12')
  spec.add_dependency('sinatra-activerecord', '1.2.2')
end
