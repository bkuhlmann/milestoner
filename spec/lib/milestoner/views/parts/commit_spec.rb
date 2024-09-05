# frozen_string_literal: true

require "gitt"
require "spec_helper"

RSpec.describe Milestoner::Views::Parts::Commit do
  subject(:part) { described_class.new value: commit, rendering: view.new.rendering }

  include_context "with application dependencies"
  include_context "with enriched commit"
  include_context "with user"

  let :view do
    Class.new Hanami::View do
      config.paths = [Bundler.root.join("lib/milestoner/templates/releases")]
      config.template = "n/a"
    end
  end

  describe "#avatar_url" do
    it "answers URL for user" do
      expect(part.avatar_url(user)).to eq("https://avatars.githubusercontent.com/u/1")
    end
  end

  describe "#profile_url" do
    it "answers URL for user" do
      expect(part.profile_url(user)).to eq("https://github.com/test")
    end
  end

  describe "#kind" do
    it "answers normal when valid" do
      expect(part.kind).to eq("normal")
    end

    context "when subject has directive" do
      let(:commit) { Milestoner::Models::Commit[subject: "fixup! Added documentation"] }

      it "answers alert" do
        expect(part.kind).to eq("alert")
      end
    end

    context "when subject is unknown" do
      let(:commit) { Milestoner::Models::Commit[subject: "Created documentation"] }

      it "answers error" do
        expect(part.kind).to eq("error")
      end
    end

    context "when subject has no prefix" do
      let(:commit) { Milestoner::Models::Commit[subject: "----- Breakpoint -----"] }

      it "answers error" do
        expect(part.kind).to eq("error")
      end
    end
  end

  describe "#emoji" do
    it "answers emoji" do
      expect(part.emoji).to eq("🟢")
    end

    context "when subject has directive" do
      let(:commit) { Milestoner::Models::Commit[subject: "fixup! Added documentation"] }

      it "answers alert emoji" do
        expect(part.emoji).to eq("🔶")
      end
    end

    context "when subject is invalid" do
      let(:commit) { Milestoner::Models::Commit[subject: "Created documentation"] }

      it "answers alert emoji" do
        expect(part.emoji).to eq("🔶")
      end
    end
  end

  describe "#icon" do
    it "answers specific icon for known subject" do
      expect(part.icon).to eq("added")
    end

    context "when subject has directive" do
      let(:commit) { Milestoner::Models::Commit[subject: "fixup! Added documentation"] }

      it "answers rebase icon" do
        expect(part.icon).to eq("rebase")
      end
    end

    context "when subject is invalid" do
      let(:commit) { Milestoner::Models::Commit[subject: "Created documentation"] }

      it "answers invalid icon" do
        expect(part.icon).to eq("invalid")
      end
    end
  end

  describe "#total_deletions" do
    it "answers total" do
      expect(part.total_deletions).to eq("-10")
    end
  end

  describe "#total_insertions" do
    it "answers total" do
      expect(part.total_insertions).to eq("+5")
    end

    context "when zero" do
      let(:commit) { Milestoner::Models::Commit[insertions: 0] }

      it "answers zero" do
        expect(part.total_insertions).to eq("0")
      end
    end
  end

  describe "#tag" do
    it "answers version when subject is valid" do
      expect(part.tag).to eq("patch")
    end

    context "with prefix directive" do
      let(:commit) { Milestoner::Models::Commit[subject: "fixup! Added test"] }

      it "answers rebase" do
        expect(part.tag).to eq("rebase")
      end
    end

    context "with invalid prefix" do
      let(:commit) { Milestoner::Models::Commit[subject: "A test"] }

      it "answers invalid" do
        expect(part.tag).to eq("invalid")
      end
    end
  end

  describe "#safe_body" do
    let :commit do
      Milestoner::Models::Commit[
        subject: "Test",
        body: %(<a href="https://test.com">Test</a><script>Danger!</script>)
      ]
    end

    it "answers safe body" do
      expect(part.safe_body).to eq(%(<a href="https://test.com" rel="nofollow">Test</a>))
    end
  end

  describe "#safe_notes" do
    let :commit do
      Milestoner::Models::Commit[
        subject: "Test",
        notes: %(<a href="https://test.com">Test</a><script>Danger!</script>)
      ]
    end

    it "answers safe notes" do
      expect(part.safe_notes).to eq(%(<a href="https://test.com" rel="nofollow">Test</a>))
    end
  end

  describe "#security" do
    it "answers secure with valid signature" do
      expect(part.security).to eq("secure")
    end

    context "with invalid signature" do
      let(:commit) { Milestoner::Models::Commit[signature: "Bad"] }

      it "answers insecure" do
        expect(part.security).to eq("insecure")
      end
    end
  end

  describe "#at" do
    it "answers machine readable date and time" do
      expect(part.at).to eq("2023-01-01T17:10:10+0000")
    end
  end

  describe "#datetime" do
    it "answers human friendly date and time" do
      expect(part.datetime).to eq("2023-01-01 (Sunday) at 17:10 PM UTC")
    end
  end

  describe "#weekday" do
    it "answers weekday" do
      expect(part.weekday).to eq("Sunday")
    end
  end

  describe "#date" do
    it "answers date" do
      expect(part.date).to eq("2023-01-01")
    end
  end

  describe "#time" do
    it "answers time" do
      expect(part.time).to eq("17:10 PM")
    end
  end

  describe "#zone" do
    it "answers timezone" do
      expect(part.zone).to eq("UTC")
    end
  end
end
