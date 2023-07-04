# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::CLI::Actions::Build::Version do
  using Versionaire::Cast

  subject(:action) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    it "answers default version" do
      action.call
      expect(input.project_version).to match(/\d+\.\d+\.\d+/)
    end

    it "answers custom version" do
      action.call "0.0.0"
      expect(input.project_version).to eq(Version("0.0.0"))
    end
  end
end
