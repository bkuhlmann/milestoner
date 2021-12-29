# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::CLI::Parsers::Core do
  using Versionaire::Cast

  subject(:parser) { described_class.new }

  include_context "with application container"

  it_behaves_like "a parser"

  describe "#call" do
    it "answers config edit (short)" do
      expect(parser.call(%w[-c edit])).to have_attributes(action_config: :edit)
    end

    it "answers config edit (long)" do
      expect(parser.call(%w[--config edit])).to have_attributes(action_config: :edit)
    end

    it "answers config view (short)" do
      expect(parser.call(%w[-c view])).to have_attributes(action_config: :view)
    end

    it "answers config view (long)" do
      expect(parser.call(%w[--config view])).to have_attributes(action_config: :view)
    end

    it "fails with missing config action" do
      expectation = proc { parser.call %w[--config] }
      expect(&expectation).to raise_error(OptionParser::MissingArgument, /--config/)
    end

    it "fails with invalid config action" do
      expectation = proc { parser.call %w[--config bogus] }
      expect(&expectation).to raise_error(OptionParser::InvalidArgument, /bogus/)
    end

    it "answers publish version (short)" do
      expect(parser.call(%w[-P 0.0.0])).to have_attributes(
        action_publish: true,
        version: Version("0.0.0")
      )
    end

    it "answers publish version (long)" do
      expect(parser.call(%w[--publish 0.0.0])).to have_attributes(
        action_publish: true,
        version: Version("0.0.0")
      )
    end

    it "fails publish with invalid version" do
      expectation = proc { parser.call %w[--publish bogus] }
      expect(&expectation).to raise_error(OptionParser::InvalidArgument, /bogus/)
    end

    it "enables status (short)" do
      expect(parser.call(%w[-s])).to have_attributes(action_status: true)
    end

    it "enables status (long)" do
      expect(parser.call(%w[--status])).to have_attributes(action_status: true)
    end

    it "answers version (short)" do
      expect(parser.call(%w[-v])).to have_attributes(action_version: true)
    end

    it "answers version (long)" do
      expect(parser.call(%w[--version])).to have_attributes(action_version: true)
    end

    it "enables help (short)" do
      expect(parser.call(%w[-h])).to have_attributes(action_help: true)
    end

    it "enables help (long)" do
      expect(parser.call(%w[--help])).to have_attributes(action_help: true)
    end
  end
end
