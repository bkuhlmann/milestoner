# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Pusher do
  let(:git) { instance_spy Milestoner::Git::Kit }
  subject { described_class.new git: git }

  describe "#push" do
    it "successfully pushes tags to remote repository" do
      allow(git).to receive(:push_tags).and_return("")
      result = -> { subject.push }

      expect(&result).to output("").to_stdout
    end

    it "fails when remote repository is not configured" do
      allow(git).to receive(:remote?).and_return(false)
      result = -> { subject.push }

      expect(&result).to raise_error(
        Milestoner::Errors::Git,
        "Git remote repository not configured."
      )
    end

    it "fails when push fails" do
      allow(git).to receive(:push_tags).and_return("error")
      result = -> { subject.push }

      expect(&result).to raise_error(
        Milestoner::Errors::Git,
        "Git tags could not be pushed to remote repository."
      )
    end
  end
end
