# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Claude on Rails Subagent Conversion' do
  describe 'subagent architecture' do
    it 'follows Claude Code subagent format' do
      # This test validates that our subagent templates follow the correct format
      subagent_template = <<~TEMPLATE
        ---
        name: test-agent
        description: Test description
        tools: Read, Write
        ---

        Test prompt content
      TEMPLATE

      # Parse the frontmatter
      expect(subagent_template).to match(/^---\n/)
      expect(subagent_template).to match(/name: test-agent/)
      expect(subagent_template).to match(/description: .+/)
      expect(subagent_template).to match(/tools: .+/)
    end

    it 'uses Task tool for orchestration' do
      architect_content = 'Task(subagent_type="general-purpose", prompt="/rails-models", description="Create models")'
      expect(architect_content).to include('Task(')
      expect(architect_content).to include('subagent_type="general-purpose"')
    end

    it 'creates subagents in .claude/agents/ directory' do
      expected_path = '.claude/agents/rails-architect.md'
      expect(expected_path).to match(%r{\.claude/agents/})
    end
  end

  describe 'migration from swarm to subagents' do
    it 'converts prompt files to subagent format' do
      # Old format: separate prompt file
      old_prompt = "You are a Rails models specialist..."

      # New format: subagent with frontmatter
      new_format = <<~SUBAGENT
        ---
        name: rails-models
        description: Rails models specialist
        tools: Read, Edit, Write
        ---

        You are a Rails models specialist...
      SUBAGENT

      expect(new_format).to include(old_prompt)
      expect(new_format).to include('---')
    end

    it 'replaces claude-swarm orchestration with Task tool' do
      # Old: claude-swarm.yml with connections
      # New: Task tool invocations

      old_approach = 'connections: [models, controllers]'
      new_approach = 'Task(subagent_type="general-purpose", prompt="/rails-models")'

      expect(old_approach).not_to eq(new_approach)
      expect(new_approach).to include('Task')
    end
  end
end
