$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'foundation/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'foundation-api'
  s.version     = Foundation::VERSION
  s.authors     = ['Jack Jennings']
  s.email       = ['j@ckjennin.gs']
  s.homepage    = 'http://github.com/noeassociates/foundation-api'
  s.summary     = 'API for expressing interest in building units'
  s.description = 'API for expressing interest in building units'
  s.license     = 'MIT'

  s.files = Dir['lib/**/*', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'grape'
  s.add_dependency 'grape-entity'
  s.add_dependency 'hashie-forbidden_attributes'
  s.add_dependency 'sinatra'
  s.add_dependency 'email_regex'
  s.add_dependency 'rack-cors'
  s.add_dependency 'activesupport', '~> 4.2'

  s.add_development_dependency 'minitest'
  s.add_development_dependency 'rack-test'
  s.add_development_dependency 'rack-rewrite'
  s.add_development_dependency 'rake'

end
