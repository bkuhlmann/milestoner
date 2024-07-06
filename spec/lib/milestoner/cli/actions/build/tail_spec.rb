# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::CLI::Actions::Build::Tail do
  subject(:action) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    it "answers default version" do
      action.call
      expect(settings.build_tail).to match("head")
    end

    it "answers custom version" do
      action.call "tag"
      expect(settings.build_tail).to eq("tag")
    end
  end
end
