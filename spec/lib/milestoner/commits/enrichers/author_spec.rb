# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Commits::Enrichers::Author do
  subject(:enricher) { described_class.new }

  include_context "with application dependencies"
  include_context "with user"

  describe "#call" do
    it "answers user when found in cache" do
      record = user
      cache.commit(:users) { upsert record }
      commit = Gitt::Models::Commit[author_name: "Test"]

      expect(enricher.call(commit)).to eq(user)
    end

    it "answers empty user not found in cache" do
      commit = Gitt::Models::Commit[author_name: "Test"]
      expect(enricher.call(commit)).to eq(Milestoner::Models::User.new)
    end
  end
end
