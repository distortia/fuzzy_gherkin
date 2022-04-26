# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fuzzy_gherkin/version'

Gem::Specification.new do |spec|
  spec.name          = 'fuzzy_gherkin'
  spec.version       = FuzzyGherkin::VERSION
  spec.authors       = ['Nick Stalter']
  spec.email         = ['nickstalter@gmail.com']

  spec.summary       = %q({Fuzzy Matching Gherkin steps})
  spec.description   = %q({Fuzzy Matching Gherkin steps to show where potential similarities may exist and where code can be refactored or combined.})
  spec.homepage      = 'https://gitlab.com/distortia/fuzzy_gherkin'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'fuzzy-string-match', '~> 0.9.7'
  spec.add_dependency 'pry', '~> 0.10.4'
  spec.add_dependency 'gherkin', '~> 4.0'
  spec.add_dependency 'json', '~> 2.0', '>= 2.0.2'
  spec.add_dependency 'thor', "~> 0"

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 13.0'

end
