Gem::Specification.new do |gem|
  gem.name        = 'triton-ops'
  gem.version     = `git describe --tags --abbrev=0`.chomp + '.pre'
  gem.licenses    = 'MIT'
  gem.authors     = ['Chris Olstrom']
  gem.email       = 'chris@olstrom.com'
  gem.homepage    = 'https://github.com/colstrom/triton-ops'
  gem.summary     = 'A Ruby Interface for Triton Operators'

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'contracts',   '~> 0.16', '>= 0.16.0'
  gem.add_runtime_dependency 'pastel',      '~> 0.7',  '>= 0.7.0'
  gem.add_runtime_dependency 'redis',       '~> 4.0',  '>= 4.0.0'
  gem.add_runtime_dependency 'tty-prompt',  '~> 0.15', '>= 0.15.0'
  gem.add_runtime_dependency 'tty-spinner', '~> 0.8',  '>= 0.8.0'
  gem.add_runtime_dependency 'tty-table',   '~> 0.9',  '>= 0.9.0'
end
