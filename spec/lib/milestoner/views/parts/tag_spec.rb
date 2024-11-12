# frozen_string_literal: true

require "gitt"
require "spec_helper"

RSpec.describe Milestoner::Views::Parts::Tag do
  using Refinements::Struct

  subject(:part) { described_class.new value: tag, rendering: view.new.rendering }

  include_context "with application dependencies"
  include_context "with enriched tag"
  include_context "with user"

  let :view do
    Class.new Hanami::View do
      config.paths = [Bundler.root.join("lib/milestoner/templates")]
      config.template = "n/a"
    end
  end

  describe "#commit_count" do
    it "answers count" do
      expect(part.commit_count).to eq(1)
    end
  end

  describe "#committed_at" do
    let(:at) { Time.new 2024, 7, 4, 2, 2, 2 }

    it "answers actual" do
      expect(part.committed_at).to eq(at)
    end

    it "answers fallback" do
      tag.committed_at = nil
      expect(part.committed_at(fallback: at)).to eq(at)
    end
  end

  describe "#committed_date" do
    it "answers year, month, and day" do
      expect(part.committed_date).to eq("2024-07-04")
    end
  end

  describe "#committed_datetime" do
    it "answers RFC 3339 format for year, month, day, hour, minute, second, and time zone" do
      expect(part.committed_datetime).to eq("2024-07-04T02:02:02-0600")
    end
  end

  describe "#deletion_count" do
    it "answers count" do
      expect(part.deletion_count).to eq(10)
    end
  end

  describe "#empty?" do
    it "answers true when empty" do
      tag.commits.clear
      expect(part.empty?).to be(true)
    end

    it "answers false when not empty" do
      expect(part.empty?).to be(false)
    end
  end

  describe "#file_count" do
    it "answers count" do
      expect(part.file_count).to eq(2)
    end
  end

  describe "#insertion_count" do
    it "answers count" do
      expect(part.insertion_count).to eq(5)
    end
  end

  describe "#security" do
    it "answers good when secure" do
      expect(part.security).to eq("🔒 Tag (secure)")
    end

    it "answers invalid when insecure" do
      tag.signature = nil
      expect(part.security).to eq("🔓 Tag (insecure)")
    end
  end

  describe "#total_commits" do
    it "answers singular" do
      expect(part.total_commits).to eq("1 commit")
    end

    it "answers plural" do
      tag.commits.append commit
      expect(part.total_commits).to eq("2 commits")
    end
  end

  describe "#total_files" do
    it "answers singular" do
      tag.commits = [commit.merge(files_changed: 1)]
      expect(part.total_files).to eq("1 file")
    end

    it "answers plural" do
      expect(part.total_files).to eq("2 files")
    end
  end

  describe "#total_deletions" do
    it "answers singular" do
      tag.commits = [commit.merge(deletions: 1)]
      expect(part.total_deletions).to eq("1 deletion")
    end

    it "answers plural" do
      expect(part.total_deletions).to eq("10 deletions")
    end
  end

  describe "#total_insertions" do
    it "answers singular" do
      tag.commits = [commit.merge(insertions: 1)]
      expect(part.total_insertions).to eq("1 insertion")
    end

    it "answers plural" do
      expect(part.total_insertions).to eq("5 insertions")
    end
  end

  describe "#uri" do
    it "answers URI" do
      expect(part.uri).to eq("https://undefined.io/projects/test/versions/0.0.0")
    end
  end
end
