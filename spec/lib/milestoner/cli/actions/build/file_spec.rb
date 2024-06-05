# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::CLI::Actions::Build::File do
  subject(:action) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    it "answers default path" do
      action.call
      expect(settings.build_file).to eq("index.%<extension>s")
    end

    it "answers custom path" do
      action.call "alternative.%<extension>s"
      expect(settings.build_file).to eq("alternative.%<extension>s")
    end
  end
end
