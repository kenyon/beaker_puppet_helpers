# frozen_string_literal: true

begin
  require 'voxpupuli/rubocop/rake'
rescue LoadError
  # the voxpupuli-rubocop gem is optional
end

begin
  require 'rspec/core/rake_task'
rescue LoadError
  # No rspec
else
  RSpec::Core::RakeTask.new
end

begin
  require 'yard'
rescue LoadError
  # No yardoc
else
  YARD::Rake::YardocTask.new
end

desc <<~DESC
  Run the acceptance tests

  Accepted environment variables:
   * TESTS=acceptance/tests
   * BEAKER_HOSTS=config/nodes/foo.yaml or specify in a form beaker-hostgenerator accepts, e.g. ubuntu2004-64a.
   * BEAKER_LOG_LEVEL=debug
   * BEAKER_PRESERVE_HOSTS=onfail
   * BEAKER_OPTIONS='--more --options'
DESC
task :acceptance do
  hosts = {
    aio: %w[centos9 debian11 debian12],
    foss: %w[debian11 debian12 fedora37 fedora38],
  }
  default_hosts = hosts.map { |type, h| h.map { |host| "#{host}-64{type=#{type}}" }.join('-') }.join('-')
  hosts = ENV['BEAKER_HOSTS'] || default_hosts

  tests = ENV['TESTS'] || 'acceptance/tests'
  log_level = ENV['BEAKER_LOG_LEVEL'] || 'debug'
  preserve_hosts = ENV['BEAKER_PRESERVE_HOSTS'] || 'onfail'

  args = [
    "--hosts=#{hosts}",
    "--tests=#{tests}",
    "--log-level=#{log_level}",
    "--preserve-hosts=#{preserve_hosts}",
  ] + ENV['BEAKER_OPTIONS'].to_s.split

  sh('beaker', *args.compact)
end

desc 'Run the entire test suite'
task test: %w[rubocop spec acceptance]

task default: :test

begin
  require 'github_changelog_generator/task'
rescue LoadError
  # No changelog generator
else
  GitHubChangelogGenerator::RakeTask.new :changelog do |config|
    config.header = "# Changelog\n\nAll notable changes to this project will be documented in this file."
    config.exclude_labels = %w[duplicate question invalid wontfix wont-fix skip-changelog github_actions]
    config.user = 'voxpupuli'
    config.project = 'beaker_puppet_helpers'
    config.future_release = Gem::Specification.load("#{config.project}.gemspec").version.to_s
  end
end
