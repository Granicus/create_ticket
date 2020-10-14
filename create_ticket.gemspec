# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'create_ticket/version'

Gem::Specification.new do |spec|
  spec.name          = 'create_ticket'
  spec.version       = CreateTicket::VERSION
  spec.authors       = ['Kyle Marek-Spartz']
  spec.email         = ['kyle.marekspartz@govdelivery.com']

  spec.summary       = 'Create JIRA tickets'
  spec.description   = 'Create JIRA tickets'
  spec.homepage      = 'https://github.com/govdelivery/create_ticket'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 2.6.0'
  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rubocop', '~> 0.81'

  spec.add_dependency 'faraday'
  spec.add_dependency 'highline'
  spec.add_dependency 'json'
  spec.add_dependency 'kramdown-parser-gfm'
  spec.add_dependency 'markdown2confluence'
end
