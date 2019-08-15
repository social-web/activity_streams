# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'social_web-activity_streams'
  s.version = '0.1.1'
  s.authors = ['Shane Cavanaugh']
  s.email = ['shane@shanecav.net']

  s.summary = 'Models for ActivityStreams'
  s.description = s.summary
  s.homepage = 'https://github.com/social-web/activity_streams'
  s.license = 'MIT'

  s.metadata['homepage_uri'] = s.homepage
  s.metadata['source_code_uri'] = s.homepage
  s.metadata['changelog_uri'] = 'https://github.com/social-web/activity_streams/tree/master/CHANGELOG.md'

  s.files = %w[LICENSE.txt] + Dir['{lib,spec}/**/*']
  s.require_path = 'lib'

  s.required_ruby_version = '>= 1.9.2'

  s.add_dependency 'activemodel', '>= 5.2.3'
  s.add_dependency 'roda', '>= 3.22.0'

  s.add_development_dependency 'bundler', '~> 2.0'
  s.add_development_dependency 'rack-test', '~> 1.0'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'simplecov', '~> 0.1'
end
