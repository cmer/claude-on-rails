# frozen_string_literal: true

require 'rails/generators/base'
require 'claude_on_rails'

module ClaudeOnRails
  module Generators
    class SubagentsGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      class_option :api_only, type: :boolean, default: false,
                              desc: 'Generate subagents for API-only Rails application'

      class_option :skip_tests, type: :boolean, default: false,
                                desc: 'Skip test agent in subagent configuration'

      class_option :graphql, type: :boolean, default: false,
                             desc: 'Include GraphQL specialist agent'

      class_option :turbo, type: :boolean, default: true,
                           desc: 'Include Turbo/Stimulus specialist agents'

      def analyze_project
        say 'Analyzing Rails project structure for Claude Code subagents...', :green
        @project_analysis = ClaudeOnRails.analyze_project(Rails.root)

        # Auto-detect features
        @api_only = options[:api_only] || @project_analysis[:api_only]
        @has_graphql = options[:graphql] || @project_analysis[:has_graphql]
        @has_turbo = options[:turbo] && !@api_only
        @skip_tests = options[:skip_tests]
        @test_framework = @project_analysis[:test_framework]

        say "Project type: #{@api_only ? 'API-only' : 'Full-stack Rails'}", :cyan
        say "Test framework: #{@test_framework}", :cyan if @test_framework
        say "GraphQL detected: #{@has_graphql ? 'Yes' : 'No'}", :cyan
        say "Turbo/Stimulus: #{@has_turbo ? 'Yes' : 'No'}", :cyan
      end

      def create_directory_structure
        say 'Creating Claude Code subagents directory...', :green
        empty_directory '.claude/agents'
      end

      def create_subagents
        say 'Creating Rails development subagents...', :green

        # Always create the architect/orchestrator
        template 'agents/rails-architect.md.erb', '.claude/agents/rails-architect.md'

        # Core subagents
        template 'agents/rails-models.md', '.claude/agents/rails-models.md'
        template 'agents/rails-controllers.md', '.claude/agents/rails-controllers.md'
        template 'agents/rails-services.md', '.claude/agents/rails-services.md'
        template 'agents/rails-jobs.md', '.claude/agents/rails-jobs.md'
        template 'agents/rails-devops.md', '.claude/agents/rails-devops.md'

        # Conditional subagents
        template 'agents/rails-views.md', '.claude/agents/rails-views.md' unless @api_only

        template 'agents/rails-api.md', '.claude/agents/rails-api.md' if @api_only

        template 'agents/rails-graphql.md', '.claude/agents/rails-graphql.md' if @has_graphql

        template 'agents/rails-stimulus.md', '.claude/agents/rails-stimulus.md' if @has_turbo

        return if @skip_tests

        template 'agents/rails-tests.md.erb', '.claude/agents/rails-tests.md'
      end

      def update_or_create_claude_md
        claude_md_path = Rails.root.join('CLAUDE.md')

        if File.exist?(claude_md_path)
          say 'Existing CLAUDE.md found. Adding Claude on Rails subagents note...', :yellow

          content = File.read(claude_md_path)

          if content.include?('Claude on Rails Subagents')
            say 'CLAUDE.md already references Claude on Rails subagents', :cyan
          else
            append_to_file claude_md_path, <<~CONTENT

              ## Claude on Rails Subagents

              This project has Rails development subagents configured in `.claude/agents/`.#{' '}
              The `rails-architect` subagent orchestrates specialized agents for different Rails domains.

              To start Rails development, mention "rails-architect" or describe what you want to build.
            CONTENT
            say 'Added Claude on Rails subagents reference to CLAUDE.md', :green
          end
        else
          say 'Creating CLAUDE.md with Rails development guidance...', :green
          template 'CLAUDE.md.erb', 'CLAUDE.md'
        end
      end

      def show_next_steps
        say "\n✅ Claude on Rails subagents have been configured!", :green
        say "\nHow to use:", :cyan
        say "  1. Simply describe what you want to build in Rails", :cyan
        say "  2. Claude will automatically delegate to the rails-architect subagent", :cyan
        say "  3. The architect will coordinate specialized subagents as needed", :cyan

        say "\n📝 Example prompts:", :yellow
        say '  "Add user authentication with email confirmation"', :yellow
        say '  "Create a REST API for blog posts with comments"', :yellow
        say '  "Build a real-time chat feature using Turbo"', :yellow

        say "\n💡 Available specialists:", :cyan
        say "  - rails-architect: Orchestrates all Rails development", :cyan
        say "  - rails-models: Database and ActiveRecord expert", :cyan
        say "  - rails-controllers: Routing and request handling", :cyan
        say "  - rails-services: Business logic patterns", :cyan

        say "  - rails-views: UI and templates", :cyan unless @api_only

        say "  - rails-graphql: GraphQL API development", :cyan if @has_graphql

        say "\n🚀 The rails-architect will automatically coordinate the right specialists for your task!", :green
      end

      private

      def agents
        list = %w[models controllers services jobs devops]
        list << 'views' unless @api_only
        list << 'api' if @api_only
        list << 'graphql' if @has_graphql
        list << 'stimulus' if @has_turbo
        list << 'tests' unless @skip_tests
        list
      end
    end
  end
end
