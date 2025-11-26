# frozen_string_literal: true

require 'optparse'

module SubmodulerChild
  class CLI
    COMMANDS = {
      'init' => 'Initialize a new Submoduler child submodule',
      'status' => 'Display status of the child submodule',
      'test' => 'Run tests in the child submodule',
      'version' => 'Display and manage version information',
      'build' => 'Build the child submodule gem package',
      'symlink_build' => 'Build symlinks from vendor gems to child .kiro/steering'
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

      verify_child_context

      execute_command
    rescue StandardError => e
      puts "Error: #{e.message}"
      1
    end

    private

    def verify_child_context
      # Skip verification for init command
      return if @command == 'init'
      
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
      when 'init'
        require_relative 'init_command'
        InitCommand.new(@args).execute
      when 'status'
        StatusCommand.new(@args).execute
      when 'test'
        TestCommand.new(@args).execute
      when 'version'
        VersionCommand.new(@args).execute
      when 'symlink_build'
        require_relative 'symlink_build_command'
        SymlinkBuildCommand.run
        0
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
