# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::CLI::Parsers::Security do
  using Refinements::Structs

  subject(:parser) { described_class.new configuration.dup }

  include_context "with application container"

  it_behaves_like "a parser"

  describe "#call" do
    it "enables tag signing" do
      expect(parser.call(%w[--sign])).to have_attributes(sign: true)
    end

    it "disables tag signing" do
      expect(parser.call(%w[--no-sign])).to have_attributes(sign: false)
    end

    it "fails when sign is not a boolean" do
      parser = described_class.new
      allow(configuration).to receive(:sign).and_return "bogus"
      parser.call %w[--sign]

      expect(logger.reread).to match(/--sign must be a boolean/)
    end
  end
end
