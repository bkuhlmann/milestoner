# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::CLI::Actions::Next do
  using Versionaire::Cast

  subject(:action) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    it "answers next version" do
      action.call
      expect(kernel).to have_received(:puts).with(Version("1.2.3"))
    end
  end
end
