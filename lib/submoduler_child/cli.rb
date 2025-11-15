# frozen_string_literal: true

require 'optparse'

module SubmodulerChild
  class CLI
    COMMANDS = {
      'status' => 'Display status of the child submodule',
      'test' => 'Run tests in the child submodule',
      'version' => 'Display and manage version information',
      'build' => 'Build the child submodule gem package'
    }.freeze

    def self.run(args)
      new(args).run
    end

    def initialize(args)
      @args = args
      @command = nil
      @options = {}
    end

    def run
      verify_child_context

      if @args.empty?
        display_help
        return 1
      end

      @command = @args.shift

      unless COMMANDS.key?(@command)
        puts "Error: Unknown command '#{@command}'"
        display_help
        return 1
      end

      execute_command
    rescue StandardError => e
      puts "Error: #{e.message}"
      1
    end

    private

    def verify_child_context
      config_file = '.submoduler.ini'
      
      unless File.exist?(config_file)
        raise "Not in a Submoduler directory. Missing #{config_file}"
      end

      content = File.read(config_file)
      
      unless content.match?(/childname\s*=/)
        raise "Invalid .submoduler.ini: missing 'childname' configuration"
      end
    end

    def execute_command
      case @command
      when 'status'
        StatusCommand.new(@args).execute
      when 'test'
        TestCommand.new(@args).execute
      when 'version'
        VersionCommand.new(@args).execute
      when 'build'
        puts "Build command not yet implemented"
        0
      else
        puts "Error: Command '#{@command}' not implemented"
        1
      end
    end

    def display_help
      puts "Submoduler Child - Manage child submodule operations"
      puts ""
      puts "Usage: bin/submoduler_child.rb <command> [options]"
      puts ""
      puts "Available commands:"
      COMMANDS.each do |cmd, desc|
        puts "  #{cmd.ljust(12)} #{desc}"
      end
      puts ""
      puts "Run 'bin/submoduler_child.rb <command> --help' for command-specific options"
    end
  end
end
