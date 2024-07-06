# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::CLI::Actions::Build::Format do
  subject(:action) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    it "answers default version" do
      action.call
      expect(settings.build_format).to match("stream")
    end

    it "answers custom version" do
      action.call "feed"
      expect(settings.build_format).to eq("feed")
    end
  end
end
