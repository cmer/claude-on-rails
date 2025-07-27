# ClaudeOnRails

[![Gem Version](https://badge.fury.io/rb/claude-on-rails.svg?cache_bust=0.1.4)](https://badge.fury.io/rb/claude-on-rails)
[![CI](https://github.com/obie/claude-on-rails/actions/workflows/main.yml/badge.svg)](https://github.com/obie/claude-on-rails/actions/workflows/main.yml)


A Rails development framework that leverages [claude-swarm](https://github.com/parruda/claude-swarm) to create an intelligent team of AI agents specialized in different aspects of Rails development.

Instead of managing personas manually, ClaudeOnRails automatically orchestrates a swarm of specialized agents that work together like a real development team. Simply describe what you want to build, and the swarm handles the rest.

## How It Works

ClaudeOnRails leverages Claude Code's native subagent feature to create a team of specialized AI agents:

- **rails-architect**: Orchestrates development and coordinates other specialists
- **rails-models**: Handles ActiveRecord, migrations, and database design
- **rails-controllers**: Manages routing and request handling
- **rails-views**: Creates UI templates and manages assets
- **rails-services**: Implements business logic and service objects
- **rails-tests**: Ensures comprehensive test coverage
- **rails-devops**: Handles deployment and infrastructure

The architect subagent automatically delegates work to appropriate specialists based on your request.

## Installation

Add to your Rails application's Gemfile:

```ruby
group :development do
  gem 'claude-on-rails'
end
```

Then run:

```bash
bundle install
rails generate claude_on_rails:subagents
```

During generation, you'll be offered to set up Rails MCP Server for enhanced documentation access. Simply press Y when prompted!

This will:
- Analyze your Rails project structure
- Create Claude Code subagents in `.claude/agents/`
- Configure the rails-architect orchestrator
- Set up specialized subagents based on your project type
- Update or create CLAUDE.md with usage instructions

For detailed setup instructions, see [SETUP.md](./SETUP.md).

## Usage

### Claude Code Subagents

After running the generator, simply open your Rails project in Claude Code and describe what you want to build:

```
Add user authentication with email confirmation
```

The rails-architect subagent will automatically:
- Analyze your request
- Coordinate appropriate specialists using Claude Code's Task tool
- Implement across all layers (models, controllers, views, tests)
- Follow Rails best practices
- Ensure test coverage

### Example Interactions

```
Create a blog with comments and categories
[rails-architect coordinates models, controllers, views, and tests specialists]

Build a REST API for user management
[rails-architect delegates to models, controllers, api, and tests specialists]

Add real-time notifications using Turbo
[rails-architect engages stimulus and controllers specialists]

Optimize database queries for the dashboard
[rails-architect works with models specialist on query optimization]
```

## How It's Different

### Traditional Rails Development with AI
When using AI assistants for Rails development, you typically need to:
- Manually coordinate different aspects of implementation
- Switch contexts between models, controllers, views, and tests
- Ensure consistency across different parts of your application
- Remember to implement tests, security, and performance considerations

### ClaudeOnRails Approach
With ClaudeOnRails, you simply describe what you want in natural language:
```
Create a user system with social login
```

The rails-architect subagent automatically:
- Creates models with proper validations and associations
- Implements controllers with authentication logic  
- Builds views with forms and UI components
- Adds comprehensive test coverage
- Handles security considerations
- Optimizes database queries

All coordinated through Claude Code's native subagent system.

## Project Structure

After running the generator, you'll have:

```
your-rails-app/
├── .claude/
│   └── agents/                  # Claude Code subagents
│       ├── rails-architect.md   # Main orchestrator
│       ├── rails-models.md      # Database specialist
│       ├── rails-controllers.md # Controllers specialist
│       └── ...                  # Other specialists
└── CLAUDE.md                    # Project guidance for Claude Code
```

## Customization

### Subagent Configuration

The generated subagents in `.claude/agents/` can be customized:
- Edit the system prompts to add project-specific conventions
- Modify tool access for specific agents
- Add domain knowledge and coding standards

### Creating Additional Subagents

You can create custom subagents for your specific needs:

```markdown
---
name: rails-analytics
description: Analytics and reporting specialist for Rails applications
tools: Read, Edit, Write, Bash, Grep
---

Your custom subagent prompt here...
```

## Features

- **Native Claude Code Integration**: Uses Claude Code's built-in subagent system
- **Automatic Orchestration**: rails-architect coordinates specialists automatically
- **Rails-Aware**: Deep understanding of Rails conventions and best practices
- **Project Adaptation**: Detects your project structure and creates relevant agents
- **Test-Driven**: Automatic test generation for all code
- **Performance Focus**: Built-in optimization capabilities

## Enhanced Documentation with Rails MCP Server

ClaudeOnRails integrates with [Rails MCP Server](https://github.com/maquina-app/rails-mcp-server) to provide your AI agents with real-time access to Rails documentation and best practices.

### Benefits

- **Up-to-date Documentation**: Agents access current Rails guides matching your version
- **Framework Resources**: Includes Turbo, Stimulus, and Kamal documentation
- **Consistent Standards**: All agents share the same documentation source
- **Reduced Hallucination**: Agents verify patterns against official documentation

### Automated Setup

When you run `rails generate claude_on_rails:swarm`, you'll be prompted to set up Rails MCP Server automatically. Just press Y!

If you skipped it initially, you can set it up anytime:

```bash
bundle exec rake claude_on_rails:setup_mcp
```

This interactive command will:
- Install the Rails MCP Server gem
- Configure your environment for enhanced documentation access

### Check Status

To verify your Rails MCP Server installation:

```bash
bundle exec rake claude_on_rails:mcp_status
```

### How It Works

When Rails MCP Server is available:
- Each agent can query Rails documentation in real-time
- Version-specific guidance ensures compatibility
- Agents reference canonical implementations
- Complex features follow official patterns

## Requirements

- Ruby 2.7+
- Rails 6.0+
- [claude-swarm](https://github.com/parruda/claude-swarm) gem (automatically installed as a dependency)
- Claude Code CLI

## Examples

See the [examples](./examples) directory for:
- E-commerce platform development
- API-only applications
- Real-time features with Turbo/Stimulus
- Performance optimization workflows

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines.

## License

MIT License - see [LICENSE](./LICENSE) for details.

## Acknowledgments

- Powered by [claude-swarm](https://github.com/parruda/claude-swarm)
- Built for [Claude Code](https://github.com/anthropics/claude-code)
- Integrates with [Rails MCP Server](https://github.com/maquina-app/rails-mcp-server)
