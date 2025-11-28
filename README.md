stop# Submoduler Child

Child gem for Submoduler - Git submodule management tool for managing child submodules in monorepo environments.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'submoduler-submoduler_child'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install submoduler-submoduler_child

## Usage

### Initialize a Child Submodule

To initialize a new child submodule in your project:

```bash
# Initialize with default name (current directory name)
bundle exec submoduler_child init

# Or specify a custom name
bundle exec submoduler_child init --name my-child-module
```

This will create:
- `.submoduler.ini` - Configuration file for the child submodule
- `lib/` - Library directory (if not exists)
- `spec/` - Spec directory (if not exists)
- `bin/` - Binary directory (if not exists)

### Available Commands

```bash
# Initialize a new child submodule
submoduler_child init [--name NAME]

# Display status of the child submodule
submoduler_child status

# Run tests in the child submodule
submoduler_child test

# Display and manage version information
submoduler_child version

# Build the child submodule gem package
submoduler_child build
```

### Configuration

After initialization, edit `.submoduler.ini` to configure your child submodule:

```ini
[submoduler]
childname = my-child-module
type = child

[paths]
lib = lib
spec = spec

[parent]
# Path to parent submodule (relative or absolute)
path = ../../
```

## Development

After checking out the repo, run `bundle install` to install dependencies.

## Contributing

Bug reports and pull requests are welcome.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
