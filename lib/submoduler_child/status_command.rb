# frozen_string_literal: true

require 'optparse'

module SubmodulerChild
  class StatusCommand
    def initialize(args)
      @args = args
      parse_options
    end

    def execute
      puts "Checking child submodule status..."
      puts ""
      
      check_repository_status
      check_branch_info
      
      0
    rescue StandardError => e
      puts "Error: #{e.message}"
      1
    end

    private

    def parse_options
      OptionParser.new do |opts|
        opts.banner = "Usage: bin/submoduler_child.rb status [options]"
        
        opts.on('-h', '--help', 'Display this help') do
          puts opts
          exit 0
        end
      end.parse!(@args)
    end

    def check_repository_status
      puts "Repository Status:"
      
      status_output = `git status --short 2>&1`
      
      if $?.success?
        if status_output.strip.empty?
          puts "  ✓ Working tree is clean"
        else
          puts "  ✗ Working tree has changes:"
          
          modified = []
          untracked = []
          staged = []
          
          status_output.each_line do |line|
            line = line.strip
            if line.start_with?('M ')
              modified << line[2..-1]
            elsif line.start_with?('??')
              untracked << line[3..-1]
            elsif line.start_with?('A ')
              staged << line[2..-1]
            end
          end
          
          unless staged.empty?
            puts "    Staged:"
            staged.each { |f| puts "      #{f}" }
          end
          
          unless modified.empty?
            puts "    Modified:"
            modified.each { |f| puts "      #{f}" }
          end
          
          unless untracked.empty?
            puts "    Untracked:"
            untracked.each { |f| puts "      #{f}" }
          end
        end
      else
        puts "  ✗ Error checking git status"
      end
      
      puts ""
    end

    def check_branch_info
      puts "Branch Information:"
      
      branch = `git branch --show-current 2>&1`.strip
      
      if $?.success? && !branch.empty?
        puts "  Current branch: #{branch}"
        
        # Check if branch has remote tracking
        remote_info = `git rev-list --left-right --count #{branch}...@{u} 2>&1`.strip
        
        if $?.success?
          ahead, behind = remote_info.split("\t").map(&:to_i)
          
          if ahead > 0 && behind > 0
            puts "  ⚠ Branch is #{ahead} commit(s) ahead and #{behind} commit(s) behind remote"
          elsif ahead > 0
            puts "  ↑ Branch is #{ahead} commit(s) ahead of remote"
          elsif behind > 0
            puts "  ↓ Branch is #{behind} commit(s) behind remote"
          else
            puts "  ✓ Branch is up to date with remote"
          end
        else
          puts "  ℹ No remote tracking branch"
        end
      else
        puts "  ℹ Not on any branch (detached HEAD)"
      end
    end
  end
end
