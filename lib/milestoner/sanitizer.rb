# frozen_string_literal: true

require "refinements/array"
require "sanitize"

module Milestoner
  # A custom HTML sanitizer.
  class Sanitizer
    using Refinements::Array

    def initialize defaults: Sanitize::Config::BASIC, client: Sanitize
      @defaults = defaults
      @client = client
    end

    def call(content) = client.fragment content, configuration

    private

    attr_reader :defaults, :client

    def configuration
      client::Config.merge defaults,
                           elements: defaults[:elements].including("img", "video"),
                           attributes: defaults[:attributes].merge(
                             "img" => %w[alt class height id loading src width],
                             "video" => %w[class controls height id poster src width]
                           )
    end
  end
end
