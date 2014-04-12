# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "encapsulate_as_money/version"

Gem::Specification.new do |spec|
  spec.name          = "encapsulate_as_money"
  spec.version       = EncapsulateAsMoney::VERSION
  spec.authors       = ["Orien Madgwick"]
  spec.email         = ["_@orien.io"]
  spec.summary       = "Represent Active Record model attributes as Money instances"
  spec.homepage      = "https://github.com/envato/encapsulate_as_money"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "money", ">= 5.1.0"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest-given"
end
