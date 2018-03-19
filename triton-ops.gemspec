Gem::Specification.new do |gem|
  tag = `git describe --tags --abbrev=0`.chomp

  gem.name        = 'triton-ops'
  gem.homepage    = 'https://github.com/colstrom/triton-ops'
  gem.summary     = 'A Ruby Interface for Triton Operators'

  gem.version     = "#{tag}"
  gem.licenses    = ['MIT']
  gem.authors     = ['Chris Olstrom']
  gem.email       = 'chris@olstrom.com'

  gem.cert_chain    = ['trust/certificates/colstrom.pem']
  gem.signing_key   = File.expand_path ENV.fetch 'GEM_SIGNING_KEY'

  gem.files         = `git ls-files -z`.split("\x0")
  gem.test_files    = `git ls-files -z -- {test,spec,features}/*`.split("\x0")
  gem.executables   = `git ls-files -z -- bin/*`.split("\x0").map { |f| File.basename(f) }

  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'contracts',   '~> 0.16', '>= 0.16.0'
  gem.add_runtime_dependency 'pastel',      '~> 0.7',  '>= 0.7.0'
  gem.add_runtime_dependency 'redis',       '~> 4.0',  '>= 4.0.0'
  gem.add_runtime_dependency 'tty-prompt',  '~> 0.15', '>= 0.15.0'
  gem.add_runtime_dependency 'tty-spinner', '~> 0.8',  '>= 0.8.0'
  gem.add_runtime_dependency 'tty-table',   '~> 0.9',  '>= 0.9.0'
end
