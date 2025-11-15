#!/usr/bin/env ruby
# frozen_string_literal: true

# Add lib directory to load path
$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'submoduler_child'

# Run CLI and exit with returned code
exit SubmodulerChild::CLI.run(ARGV)
