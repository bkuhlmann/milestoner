# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::CLI::Actions::Build::Output do
  subject(:action) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    it "answers default path" do
      action.call
      expect(settings.build_output).to match(Pathname.pwd.join("tmp/rspec"))
    end

    it "answers custom path (String)" do
      path = Pathname.pwd.join "alternative"
      action.call "alternative"

      expect(settings.build_output).to eq(path)
    end

    it "answers custom path (Pathname)" do
      path = Pathname.pwd.join "alternative"
      action.call path

      expect(settings.build_output).to eq(path)
    end
  end
end
