# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::CLI::Actions::Build::Stylesheet do
  subject(:action) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    it "answers default stylesheet" do
      action.call
      expect(settings.build_stylesheet).to match("page")
    end

    it "answers custom stylesheet" do
      action.call "other"
      expect(settings.build_stylesheet).to eq("other")
    end

    it "answers disabled stylesheet" do
      action.call "false"
      expect(settings.build_stylesheet).to be(false)
    end
  end
end
