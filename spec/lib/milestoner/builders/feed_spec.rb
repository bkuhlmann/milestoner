# frozen_string_literal: true

require "dry/monads"
require "spec_helper"

RSpec.describe Milestoner::Builders::Feed do
  include Dry::Monads[:result]

  using Refinements::Pathname

  subject(:builder) { described_class.new }

  include_context "with application dependencies"
  include_context "with Git repository"

  describe "#call" do
    let(:feed) { RSS::Parser.parse content }
    let(:content) { path.read }
    let(:path) { temp_dir.join "index.xml" }

    before do
      cache.write :users do |table|
        table.create Milestoner::Models::User[external_id: 1, handle: "test", name: "Test User"]
      end
    end

    it "has entries when success" do
      git_repo_dir.change_dir do
        `git tag 0.0.0`
        `touch a.txt && git add --all && git commit --message "Added A"`

        builder.call
        expect(feed.entries.size).to eq(1)
      end
    end

    it "logs path when success" do
      git_repo_dir.change_dir do
        `git tag 0.0.0`
        `touch a.txt && git add --all && git commit --message "Added A"`

        builder.call
        expect(logger.reread).to match(/🟢.+Milestone built: #{path}\./)
      end
    end

    it "answers path when success" do
      git_repo_dir.change_dir do
        `git tag 0.0.0`
        `touch a.txt && git add --all && git commit --message "Added A"`

        expect(builder.call).to eq(Success(path))
      end
    end

    it "logs error with nothing to build" do
      git_repo_dir.change_dir do
        builder.call
        expect(logger.reread).to match(/🛑.+No content to build./)
      end
    end
  end
end
