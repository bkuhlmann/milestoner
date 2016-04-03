# frozen_string_literal: true

module Milestoner
  # Default configuration for gem with support for custom settings.
  class Configuration
    def initialize file_name = Identity.file_name, defaults: {}
      @file_name = file_name
      @defaults = defaults
    end

    def local_file_path
      File.join Dir.pwd, file_name
    end

    def global_file_path
      File.join ENV["HOME"], file_name
    end

    def global?
      File.exist? global_file_path
    end

    def local?
      File.exist? local_file_path
    end

    def computed_file_path
      File.exist?(local_file_path) ? local_file_path : global_file_path
    end

    def settings
      defaults.merge(load_settings).reject { |_, value| value.nil? }
    end

    private

    attr_reader :file_name, :defaults

    def load_settings
      yaml = YAML.load_file computed_file_path
      yaml.is_a?(Hash) ? yaml : {}
    rescue
      defaults
    end
  end
end
