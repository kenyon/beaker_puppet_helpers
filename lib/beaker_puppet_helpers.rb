# frozen_string_literal: true

# A collection of helpers to make Puppet usage easier with Beaker
module BeakerPuppetHelpers
  autoload :DSL, File.join(__dir__, 'beaker_puppet_helpers', 'dsl.rb')
  autoload :InstallUtils, File.join(__dir__, 'beaker_puppet_helpers', 'install_utils.rb')
  autoload :ModuleUtils, File.join(__dir__, 'beaker_puppet_helpers', 'module_utils.rb')
  autoload :WindowsUtils, File.join(__dir__, 'beaker_puppet_helpers', 'windows_utils.rb')
end

require 'beaker'
Beaker::DSL.register(BeakerPuppetHelpers::DSL)
Beaker::DSL.register(BeakerPuppetHelpers::ModuleUtils)
Beaker::DSL.register(BeakerPuppetHelpers::WindowsUtils)
