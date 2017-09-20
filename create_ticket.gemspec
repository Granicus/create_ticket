
lib = File.expand_path('../lib', __FILE__)
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

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rubocop', '~> 0.30'

  spec.add_dependency 'faraday'
  spec.add_dependency 'json'
  spec.add_dependency 'markdown2confluence'
end
