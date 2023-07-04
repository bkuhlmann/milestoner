# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Renderers::Asciidoc do
  subject(:renderer) { described_class.new }

  describe "#call" do
    it "answers HTML" do
      html = renderer.call <<~CONTENT
        == Test

        A link:https://example.com[test] link.

        * One
        * Two
        * Three
      CONTENT

      expect(html).to eq(<<~PROOF.strip)
        <div class="sect1">
        <h2 id="_test">Test</h2>
        <div class="sectionbody">
        <div class="paragraph">
        <p>A <a href="https://example.com">test</a> link.</p>
        </div>
        <div class="ulist">
        <ul>
        <li>
        <p>One</p>
        </li>
        <li>
        <p>Two</p>
        </li>
        <li>
        <p>Three</p>
        </li>
        </ul>
        </div>
        </div>
        </div>
      PROOF
    end
  end
end
