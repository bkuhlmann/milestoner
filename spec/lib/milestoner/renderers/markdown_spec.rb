# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Renderers::Markdown do
  subject(:renderer) { described_class.new }

  describe "#call" do
    it "answers HTML" do
      html = renderer.call <<~CONTENT
        ## Test

        A [test](https://example.com) link.

        - One
        - Two
        - Three
      CONTENT

      expect(html).to eq(<<~PROOF)
        <h2>Test</h2>

        <p>A <a href="https://example.com">test</a> link.</p>

        <ul>
        <li>One</li>
        <li>Two</li>
        <li>Three</li>
        </ul>
      PROOF
    end
  end
end
