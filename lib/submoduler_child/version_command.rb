# frozen_string_literal: true

require 'optparse'

module SubmodulerChild
  class VersionCommand
    def initialize(args)
      @args = args
      @bump = nil
      @show_history = false
      parse_options
    end

    def execute
      if @show_history
        show_version_history
      elsif @bump
        bump_version
      else
        show_current_version
      end
      
      0
    rescue StandardError => e
      puts "Error: #{e.message}"
      1
    end

    def get_current_version
      version_file = find_version_file
      return "unknown" unless version_file
      
      extract_version(version_file)
    end

    private

    def parse_options
      OptionParser.new do |opts|
        opts.banner = "Usage: bin/submoduler_child.rb version [options]"
        
        opts.on('--bump TYPE', [:major, :minor, :patch], 'Bump version (major, minor, patch)') do |type|
          @bump = type
        end
        
        opts.on('--history', 'Show version history from git tags') do
          @show_history = true
        end
        
        opts.on('-h', '--help', 'Display this help') do
          puts opts
          exit 0
        end
      end.parse!(@args)
    end

    def show_current_version
      version_file = find_version_file
      
      unless version_file
        puts "Error: Could not find version.rb file"
        return 1
      end
      
      version = extract_version(version_file)
      gem_name = extract_gem_name
      
      puts "#{gem_name} version: #{version}"
    end

    def bump_version
      version_file = find_version_file
      
      unless version_file
        puts "Error: Could not find version.rb file"
        return 1
      end
      
      old_version = extract_version(version_file)
      new_version = calculate_new_version(old_version, @bump)
      
      update_version_file(version_file, old_version, new_version)
      
      puts "Version bumped: #{old_version} → #{new_version}"
    end

    def show_version_history
      tags = `git tag -l 'v*' --sort=-version:refname 2>&1`.strip
      
      if $?.success? && !tags.empty?
        puts "Version History:"
        puts ""
        
        tags.each_line do |tag|
          tag = tag.strip
          message = `git log -1 --pretty=%B #{tag} 2>&1`.strip
          puts "  #{tag}"
          puts "    #{message}" unless message.empty?
        end
      else
        puts "No version tags found"
      end
    end

    def find_version_file
      Dir.glob('lib/**/version.rb').first
    end

    def extract_version(version_file)
      content = File.read(version_file)
      
      if content =~ /VERSION\s*=\s*["']([^"']+)["']/
        $1
      else
        raise "Could not extract version from #{version_file}"
      end
    end

    def extract_gem_name
      ini = SubmodulerCommon::SubmodulerIni.new
      return 'unknown' unless ini.exist?
      
      ini.load_config
      
      master = ini.get('submoduler', 'master')&.split('/')&.last&.gsub('.git', '') || 'unknown'
      category = ini.get('submoduler', 'category') || 'unknown'
      childname = ini.child_name || 'unknown'
      
      "#{master}-#{category}-#{childname}"
    rescue SubmodulerCommon::SubmodulerIni::ConfigError
      'unknown'
    end

    def calculate_new_version(version, bump_type)
      major, minor, patch = version.split('.').map(&:to_i)
      
      case bump_type
      when :major
        "#{major + 1}.0.0"
      when :minor
        "#{major}.#{minor + 1}.0"
      when :patch
        "#{major}.#{minor}.#{patch + 1}"
      end
    end

    def update_version_file(version_file, old_version, new_version)
      content = File.read(version_file)
      updated_content = content.gsub(
        /VERSION\s*=\s*["']#{Regexp.escape(old_version)}["']/,
        "VERSION = \"#{new_version}\""
      )
      
      File.write(version_file, updated_content)
    end
  end
end
