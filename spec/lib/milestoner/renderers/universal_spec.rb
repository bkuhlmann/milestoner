# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Renderers::Universal do
  subject(:renderer) { described_class.new }

  describe "#call" do
    it "answers HTML for ASCII Doc by default" do
      html = renderer.call "link:https://example.com[test]"

      expect(html).to eq(<<~PROOF.strip)
        <div class="paragraph">
        <p><a href="https://example.com">test</a></p>
        </div>
      PROOF
    end

    it "answers HTML for ASCII Doc when specified" do
      html = renderer.call "link:https://example.com[test]", for: :asciidoc

      expect(html).to eq(<<~PROOF.strip)
        <div class="paragraph">
        <p><a href="https://example.com">test</a></p>
        </div>
      PROOF
    end

    it "answers HTML for Markdown when specified" do
      html = renderer.call "[test](https://example.com)", for: :markdown
      expect(html).to eq(%(<p><a href="https://example.com">test</a></p>\n))
    end
  end
end
