# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::CLI::Parsers::Security do
  using Refinements::Structs

  subject(:parser) { described_class.new configuration }

  include_context "with application container"

  it_behaves_like "a parser"

  describe "#call" do
    context "when sign is disabled by default" do
      let(:configuration) { application_configuration.merge git_tag_sign: false }

      it "enables tag signing" do
        parser.call %w[--sign]
        expect(configuration.git_tag_sign).to eq(true)
      end

      it "disables tag signing" do
        parser.call %w[--no-sign]
        expect(configuration.git_tag_sign).to eq(false)
      end
    end

    context "when sign is enabled by default" do
      let(:configuration) { application_configuration.merge git_tag_sign: true }

      it "enables tag signing" do
        parser.call %w[--sign]
        expect(configuration.git_tag_sign).to eq(true)
      end

      it "disables tag signing" do
        parser.call %w[--no-sign]
        expect(configuration.git_tag_sign).to eq(false)
      end
    end

    context "when sign is not a boolean" do
      let(:configuration) { application_configuration.merge git_tag_sign: nil }

      it "fails with error" do
        parse = proc { parser.call %w[--sign] }

        expect(&parse).to raise_error(
          Milestoner::Error, "--sign must be a boolean. Check gem configuration."
        )
      end
    end
  end
end
