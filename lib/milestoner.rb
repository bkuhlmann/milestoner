# frozen_string_literal: true

require "zeitwerk"

Zeitwerk::Loader.new.then do |loader|
  loader.inflector.inflect "ascii_doc" => "ASCIIDoc", "cli" => "CLI", "uri" => "URI"
  loader.tag = File.basename __FILE__, ".rb"
  loader.push_dir __dir__
  loader.setup
end

# Main namespace.
module Milestoner
  def self.loader registry = Zeitwerk::Registry
    @loader ||= registry.loaders.find { |loader| loader.tag == File.basename(__FILE__, ".rb") }
  end
end
