# frozen_string_literal: true

RSpec.shared_context "with default configuration" do
  let(:default_configuration) { Milestoner::CLI::Configuration::Loader.with_defaults.call }
end
