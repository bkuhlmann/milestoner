# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::CLI::Parsers::Core do
  using Versionaire::Cast

  subject(:parser) { described_class.new configuration }

  let(:configuration) { Milestoner::CLI::Configuration::Loader.call }

  it_behaves_like "a parser"

  describe "#call" do
    it "answers config edit (short)" do
      parser.call %w[-c edit]
      expect(configuration.action_config).to eq(:edit)
    end

    it "answers config edit (long)" do
      parser.call %w[--config edit]
      expect(configuration.action_config).to eq(:edit)
    end

    it "answers config view (short)" do
      parser.call %w[-c view]
      expect(configuration.action_config).to eq(:view)
    end

    it "answers config view (long)" do
      parser.call %w[--config view]
      expect(configuration.action_config).to eq(:view)
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
      parser.call %w[-P 0.0.0]

      expect(configuration).to have_attributes(
        action_publish: true,
        git_tag_version: Version("0.0.0")
      )
    end

    it "answers publish version (long)" do
      parser.call %w[--publish 0.0.0]

      expect(configuration).to have_attributes(
        action_publish: true,
        git_tag_version: Version("0.0.0")
      )
    end

    it "fails publish with invalid version" do
      expectation = proc { parser.call %w[--publish bogus] }
      expect(&expectation).to raise_error(OptionParser::InvalidArgument, /bogus/)
    end

    it "enables status (short)" do
      parser.call %w[-s]
      expect(configuration.action_status).to eq(true)
    end

    it "enables status (long)" do
      parser.call %w[--status]
      expect(configuration.action_status).to eq(true)
    end

    it "answers version (short)" do
      parser.call %w[-v]
      expect(configuration.action_version).to match(/Milestoner\s\d+\.\d+\.\d+/)
    end

    it "answers version (long)" do
      parser.call %w[--version]
      expect(configuration.action_version).to match(/Milestoner\s\d+\.\d+\.\d+/)
    end

    it "enables help (short)" do
      parser.call %w[-h]
      expect(configuration.action_help).to eq(true)
    end

    it "enables help (long)" do
      parser.call %w[--help]
      expect(configuration.action_help).to eq(true)
    end
  end
end
