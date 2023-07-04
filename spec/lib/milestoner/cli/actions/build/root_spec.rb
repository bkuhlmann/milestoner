# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::CLI::Actions::Build::Root do
  subject(:action) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    it "answers default version" do
      action.call
      expect(input.build_root).to match(Pathname.pwd.join("tmp/rspec"))
    end

    it "answers custom version" do
      path = Pathname.pwd.join "alternative"
      action.call path

      expect(input.build_root).to eq(path)
    end
  end
end
