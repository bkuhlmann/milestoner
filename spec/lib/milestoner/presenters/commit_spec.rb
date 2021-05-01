# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Presenters::Commit do
  subject(:presenter) { described_class.new record }

  let(:record) { GitPlus::Commit[subject: "Added documentation", author_name: "Jane Doe"] }

  it "answers subject and author" do
    expect(presenter.subject_author).to eq("Added documentation - Jane Doe")
  end
end
