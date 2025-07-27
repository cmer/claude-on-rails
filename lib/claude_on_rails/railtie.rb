# frozen_string_literal: true

require 'rails/railtie'

module ClaudeOnRails
  # Railtie to load rake tasks and generators in Rails applications
  class Railtie < Rails::Railtie
    rake_tasks do
      load File.expand_path('../tasks/claude_on_rails.rake', __dir__)
    end

    generators do
      require 'generators/claude_on_rails/swarm/swarm_generator'
      require 'generators/claude_on_rails/subagents/subagents_generator'
    end
  end
end
