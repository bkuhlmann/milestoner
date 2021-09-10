# frozen_string_literal: true

require "zeitwerk"

Zeitwerk::Loader.for_gem
                .tap { |loader| loader.inflector.inflect "cli" => "CLI" }
                .setup

# Main namespace.
module Milestoner
end
