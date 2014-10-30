Gem::Specification.new do |s|
  s.name        = 'geppeto'
  s.version     = '0.1.1'
  s.date        = '2014-10-29'
  s.summary     = "Geppeto makes Pinoccio into Ruby."
  s.description = "Geppeto provides a Ruby API to Pinoccio microcontrollers by means of a TCPsocket or a Serial connection, forgoing the need to use api.pinocc.io."
  s.authors     = ["Matt Heitzenroder"]
  s.email       = 'mheitzenroder@gmail.com'
  s.homepage    =
    'http://github.com/roder/geppeto'
  s.license       = 'Apache-2.0'

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.add_runtime_dependency 'serialport', '~> 1.2'
  s.add_runtime_dependency 'celluloid-io', '~> 0.16'
  s.add_runtime_dependency 'revolver', '~> 1.1'
  s.add_development_dependency 'bundler', '~> 1.7'
  s.add_development_dependency 'rake', '~> 10'
end
