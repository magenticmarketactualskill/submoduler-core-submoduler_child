# frozen_string_literal: true

require_relative "submoduler_child/version"
require_relative "submoduler_child/cli"
require_relative "submoduler_child/status_command"
require_relative "submoduler_child/test_command"
require_relative "submoduler_child/version_command"

module SubmodulerChild
  class Error < StandardError; end
end
