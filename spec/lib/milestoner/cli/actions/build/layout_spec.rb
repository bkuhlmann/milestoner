# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::CLI::Actions::Build::Layout do
  subject(:action) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    it "answers default layout" do
      action.call
      expect(input.build_layout).to match("page")
    end

    it "answers custom layout" do
      action.call "other"
      expect(input.build_layout).to eq("other")
    end

    it "answers disabled layout" do
      action.call "false"
      expect(input.build_layout).to be(false)
    end
  end
end
