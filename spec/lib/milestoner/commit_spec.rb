# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Commit do
  subject(:commit) { described_class.new source }

  let(:source) { GitPlus::Commit[subject: "Added documentation", author_name: "Jane Doe"] }

  it "answers subject and author" do
    expect(commit.subject_author).to eq("Added documentation - Jane Doe")
  end
end
