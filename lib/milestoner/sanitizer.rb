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

    def configuration = client::Config.merge(defaults, elements:, attributes:)

    def elements
      defaults[:elements].including "audio", "details", "img", "source", "span", "summary", "video"
    end

    def attributes
      defaults[:attributes].merge(
        all: %w[class id],
        "a" => %w[href title],
        "audio" => %w[autoplay controls controlslist crossorigin loop muted preload src],
        "details" => %w[name open],
        "img" => %w[alt height loading src width],
        "source" => %w[type src srcset sizes media height width],
        "video" => %w[controls height poster src width]
      )
    end
  end
end
