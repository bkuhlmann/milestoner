# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::CLI::Actions::Build::Format do
  subject(:action) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    it "answers default version" do
      action.call
      expect(input.build_format).to match("web")
    end

    it "answers custom version" do
      action.call "stream"
      expect(input.build_format).to eq("stream")
    end
  end
end
