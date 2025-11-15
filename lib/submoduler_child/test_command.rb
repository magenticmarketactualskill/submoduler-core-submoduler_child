# frozen_string_literal: true

require 'optparse'

module SubmodulerChild
  class TestCommand
    def initialize(args)
      @args = args
      parse_options
    end

    def execute
      puts "Running child submodule tests..."
      puts ""
      
      run_tests
      
      0
    rescue StandardError => e
      puts "Error: #{e.message}"
      1
    end

    private

    def parse_options
      OptionParser.new do |opts|
        opts.banner = "Usage: bin/submoduler_child.rb test [options]"
        
        opts.on('-h', '--help', 'Display this help') do
          puts opts
          exit 0
        end
      end.parse!(@args)
    end

    def run_tests
      if Dir.exist?('test')
        puts "Running tests..."
        
        start_time = Time.now
        system('ruby -Ilib:test test/**/*_test.rb test/**/**/test_*.rb')
        end_time = Time.now
        
        elapsed = (end_time - start_time).round(2)
        
        if $?.success?
          puts ""
          puts "✓ All tests passed (#{elapsed}s)"
        else
          puts ""
          puts "✗ Some tests failed (#{elapsed}s)"
          return 1
        end
      else
        puts "ℹ No test directory found"
      end
      
      0
    end
  end
end
