# frozen_string_literal: true

require "dry/monads"
require "spec_helper"

RSpec.describe Milestoner::Builders::ADoc::Pager do
  include Dry::Monads[:result]

  using Refinements::Struct

  subject(:builder) { described_class.new }

  include_context "with application dependencies"
  include_context "with enriched tag"

  let(:tagger) { instance_double Milestoner::Commits::Tagger, call: Success(tags) }

  describe "#call" do
    let(:path) { temp_dir.join "0.1.0/index.adoc" }
    let(:past) { tag.with version: "0.0.0" }
    let(:present) { tag.with version: "0.1.0" }
    let(:future) { tag.with version: "1.0.0" }

    it "includes logo when present" do
      settings.project_uri_logo = "https://acme.io/icon.png"
      builder.call past, present, future

      expect(path.read).to include(<<~CONTENT)
        [.text-center]
        image:https://acme.io/icon.png[Logo,100,100]
      CONTENT
    end

    it "doesn't include logo when not present" do
      settings.project_uri_logo = nil
      builder.call past, present, future

      expect(path.read).not_to match(/logo.png/)
    end

    it "includes label, version, and date" do
      builder.call past, present, future

      expect(path.read).to include(
        "== link:https://undefined.io/projects/test[Test] 0.1.0 (2024-07-04)"
      )
    end

    it "renders owner" do
      builder.call past, present, future

      expect(path.read).to include(
        "image:https://avatars.githubusercontent.com/u/1[Malcolm Reynolds,24,24] " \
        "link:https://github.com/mal[Malcolm Reynolds]"
      )
    end

    it "doesn't render owner when tags have no commits" do
      tags.each { |tag| tag.commits.clear }
      builder.call past, present, future

      expect(path.read).not_to include("Malcolm Reynolds")
    end

    it "renders secure when signature exists" do
      builder.call past, present, future
      expect(path.read).to include("🔒 Tag (secure)")
    end

    it "renders insecure when signature doesn't exist" do
      tag.signature = nil
      builder.call past, present, future

      expect(path.read).to include("🔓 Tag (insecure)")
    end

    it "renders commit summary" do
      builder.call past, present, future

      expect(path.read).to include(
        ".🟢 Added documentation - link:https://github.com/zoe[Zoe Washburne]"
      )
    end

    it "renders commit message" do
      builder.call past, present, future

      expect(path.read).to include(<<~CONTENT)
        [%collapsible]
        ====
        *Message*

        For link:https://asciidoctor.org[ASCII Doc].
      CONTENT
    end

    it "renders notes" do
      builder.call past, present, future

      expect(path.read).to include(<<~CONTENT)
        *Notes*

        For link:https://asciidoctor.org[ASCII Doc].
      CONTENT
    end

    it "renders commit author" do
      builder.call past, present, future

      expect(path.read).to include(<<~CONTENT)
        *Author*

        image:https://avatars.githubusercontent.com/u/1[Zoe Washburne,24,24] link:https://github.com/zoe[Zoe Washburne]
      CONTENT
    end

    it "renders collaborators" do
      builder.call past, present, future

      expect(path.read).to include(<<~CONTENT)
        *Collaborators*

        * image:https://avatars.githubusercontent.com/u/2[River Tam,24,24] link:https://github.com/river[River Tam]
      CONTENT
    end

    it "renders signers" do
      builder.call past, present, future

      expect(path.read).to include(<<~CONTENT)
        *Signers*

        * image:https://avatars.githubusercontent.com/u/3[Malcolm Renolds,24,24] link:https://github.com/mal[Malcolm Renolds]
      CONTENT
    end

    it "renders details" do
      builder.call past, present, future

      expect(path.read).to include(<<~CONTENT)
        *Details*

        * Milestone: Patch
        * Signature: Good
        * Files: link:https://source.firefly.com/serenity/commit/180dec7d8ae8[2]
        * Lines: -10/+5
        * Issue: link:https://issue.firefly.com/123[123]
        * Review: link:https://review.firefly.com/456[999]
        * Created: 2023-01-01 (Sunday) 10:10 AM MST
        * Updated: 2023-01-01 (Sunday) 03:15 PM MST
      CONTENT
    end

    it "renders totals" do
      builder.call past, present, future

      expect(path.read).to include(<<~CONTENT)
        *1 commit. 2 files. 10 deletions. 5 insertions.* +
        *5 hours, 5 minutes, and 5 seconds.*
      CONTENT
    end

    it "renders zero totals with no commits" do
      present = Milestoner::Models::Tag[commits: [], version: "0.1.0"]

      builder.call past, present, future

      expect(path.read).to include(<<~CONTENT)
        *0 commits. 0 files. 0 deletions. 0 insertions.*
        *0 seconds.*
      CONTENT
    end

    it "renders previous and next links" do
      builder.call past, present, future
      expect(path.read).to include("link:0.0.0/[Previous (0.0.0)] | link:1.0.0/[Next (1.0.0)]")
    end

    it "renders generator" do
      builder.call past, present, future

      expect(path.read).to include(
        "_Generated by link:https://alchemists.io/projects/milestoner[Milestoner 3.2.1]._"
      )
    end

    it "answers path when success" do
      expect(builder.call(past, present, future)).to eq(Success(path))
    end
  end
end
