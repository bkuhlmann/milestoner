# frozen_string_literal: true

require "zeitwerk"

Zeitwerk::Loader.new.then do |loader|
  loader.inflector.inflect "adoc" => "ADoc",
                           "ascii_doc" => "ASCIIDoc",
                           "cli" => "CLI",
                           "md" => "MD",
                           "uri" => "URI"
  loader.tag = File.basename __FILE__, ".rb"
  loader.push_dir __dir__
  loader.setup
end

# Main namespace.
module Milestoner
  def self.loader registry = Zeitwerk::Registry
    @loader ||= registry.loaders.each.find { |loader| loader.tag == File.basename(__FILE__, ".rb") }
  end
end
