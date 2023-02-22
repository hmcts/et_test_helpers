require_relative 'lib/et_test_helpers/version'

Gem::Specification.new do |spec|
  spec.name          = 'et_test_helpers'
  spec.version       = EtTestHelpers::VERSION
  spec.authors       = ['Gary Taylor']
  spec.email         = ['gary.taylor@hismessages.com']

  spec.summary       = 'Test helpers common to all ET applications'
  spec.description   = 'Provides test helpers, capybara etc.. to allow easy testing of ET applications (or any GDS application in rails)'
  spec.homepage      = 'https://github.com/hmcts/et_test_helpers'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['allowed_push_host'] = 'http://mygemserver.com'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/hmcts/et_test_helpers'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '> 5.0'
  spec.add_dependency 'capybara', '~> 3'
  spec.add_dependency 'i18n', '~> 1.8'
  spec.add_dependency 'rspec', '>= 3.0'
  spec.add_dependency 'site_prism', '~> 3.5'
end
