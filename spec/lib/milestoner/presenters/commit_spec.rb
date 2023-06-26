# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Presenters::Commit do
  subject(:presenter) { described_class.new record }

  include_context "with application dependencies"

  let(:record) { Gitt::Models::Commit[subject: "Added documentation", author_name: "Jane Doe"] }

  context "with Markdown format" do
    before { configuration.commit_format = "markdown" }

    it "answers subject and author with Markdown bullet" do
      expect(presenter.line_item).to eq("- Added documentation - Jane Doe")
    end
  end

  context "with ASCII Doc format" do
    before { configuration.commit_format = "asciidoc" }

    it "answers subject and author with ASCII Doc bullet" do
      expect(presenter.line_item).to eq("* Added documentation - Jane Doe")
    end
  end

  context "with unknown documenation format" do
    before { configuration.commit_format = "bogus" }

    it "answers subject and author with no bullet" do
      expect(presenter.line_item).to eq("Added documentation - Jane Doe")
    end
  end
end
