# frozen_string_literal: true

require "gitt"
require "spec_helper"

RSpec.describe Milestoner::Views::Milestones::Show do
  using Refinements::Pathname
  using Refinements::Struct

  subject(:view) { described_class.new }

  include_context "with application dependencies"
  include_context "with enriched commit"

  describe "#call" do
    it "answers no activity when there are no commits" do
      expect(view.call(commits: []).to_s).to include(%(<p class="dormant"></p>))
    end

    it "includes label" do
      expect(view.call(commits: [commit]).to_s).to include("Test")
    end

    it "includes version" do
      expect(view.call(commits: [commit]).to_s).to match(/\d+\.\d+\.\d+/)
    end

    it "includes URI" do
      expect(view.call(commits: [commit]).to_s).to include("/projects/milestoner")
    end

    it "includes date" do
      expect(view.call(commits: [], at: Time.parse("2020-01-10")).to_s).to include("2020-01-10")
    end

    it "includes datetime" do
      at = Time.utc 2020, 1, 10, 10, 10, 10
      expect(view.call(commits: [], at:).to_s).to include("2020-01-10T10:10:10+0000")
    end

    it "includes commit" do
      expect(view.call(commits: [commit]).to_s).to include("Added documentation")
    end

    it "includes total commits (singular)" do
      expect(view.call(commits: [commit]).to_s).to include("1 commit.")
    end

    it "includes total commits (plural)" do
      expect(view.call(commits: [commit, commit]).to_s).to include("2 commits.")
    end

    it "includes total files (singular)" do
      expect(view.call(commits: [commit.merge(files_changed: 1)]).to_s).to include("1 file.")
    end

    it "includes total files (plural)" do
      expect(view.call(commits: [commit]).to_s).to include("2 files.")
    end

    it "answers total deletions (singular)" do
      expect(view.call(commits: [commit.merge(deletions: 1)]).to_s).to include("1 deletion.")
    end

    it "answers total deletions (plural)" do
      expect(view.call(commits: [commit]).to_s).to include("10 deletions.")
    end

    it "answers total insertions (singular)" do
      expect(view.call(commits: [commit.merge(insertions: 1)]).to_s).to include("1 insertion.")
    end

    it "answers total insertions (plural)" do
      expect(view.call(commits: [commit]).to_s).to include("5 insertions.")
    end

    it "renders ASCIIDoc without commits" do
      expect(view.call(commits: [], format: :adoc).to_s).to include(
        "*0 commits. 0 files. 0 deletions. 0 insertions.*"
      )
    end

    it "renders ASCIIDoc with commits" do
      expect(view.call(commits: [commit], format: :adoc).to_s).to match(
        /🟢 Added documentation - _Zoe Washburne_/
      )
    end

    it "renders Markdown without commits" do
      expect(view.call(commits: [], format: :md).to_s).to include(
        "**0 commits. 0 files. 0 deletions. 0 insertions.**"
      )
    end

    it "renders Markdown with commits" do
      expect(view.call(commits: [commit], format: :md).to_s).to match(
        /🟢 Added documentation - \*Zoe Washburne\*/
      )
    end

    it "renders stream without commits" do
      expect(view.call(commits: [], format: :stream).to_s).to include(
        "0 commits. 0 files. 0 deletions. 0 insertions."
      )
    end

    it "renders stream with commits" do
      expect(view.call(commits: [commit], format: :stream).to_s).to match(
        /🟢 Added documentation - Zoe Washburne/
      )
    end
  end
end
