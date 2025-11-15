# frozen_string_literal: true

require_relative "lib/submoduler_child/version"

Gem::Specification.new do |spec|
  spec.name = "submoduler-core-submoduler_child"
  spec.version = SubmodulerChild::VERSION
  spec.authors = ["Submoduler Team"]
  spec.email = ["team@submoduler.dev"]

  spec.summary = "Child gem for Submoduler - Git submodule management tool"
  spec.description = "A child component of the Submoduler system for managing git submodules in monorepo environments"
  spec.homepage = "https://github.com/submoduler/submoduler"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/submoduler/submoduler"
  spec.metadata["changelog_uri"] = "https://github.com/submoduler/submoduler/blob/main/CHANGELOG.md"

  spec.files = Dir["lib/**/*", "README.md", "LICENSE", "CHANGELOG.md"]
  spec.require_paths = ["lib"]

  # Runtime dependencies
  # Add any runtime dependencies here
  # spec.add_dependency "example", "~> 1.0"

  # Development dependencies
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
