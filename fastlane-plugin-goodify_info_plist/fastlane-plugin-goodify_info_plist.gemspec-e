# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/goodify_info_plist/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-goodify_info_plist'
  spec.version       = Fastlane::GoodifyInfoPlist::VERSION
  spec.author        = %q{Lyndsey Ferguson}
  spec.email         = %q{ldf.public+github@outlook.com}

  spec.summary       = %q{This plugin will update the plist so that the built application can be deployed and managed within BlackBerry's Good Dynamics Control Center for Enterprise Mobility Management.}
  spec.homepage      = "https://github.com/lyndsey-ferguson/fastlane_plugins"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  # spec.add_dependency 'your-dependency', '~> 1.0.0'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'fastlane', '>= 1.95.0'
  spec.add_development_dependency 'plist'
end
