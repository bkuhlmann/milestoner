# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Sanitizer do
  subject(:sanitizer) { described_class.new }

  describe "#call" do
    it "allows image element with custom attributes" do
      image = <<~HTML.squeeze(" ").delete("\n").strip
        <img src="https://example.io/logo.png"
             alt="Logo"
             id="test"
             class="test"
             height="10"
             width="10"
             loading="lazy">
      HTML

      expect(sanitizer.call(image)).to eq(image)
    end

    it "allows video element with custom attributes" do
      video = <<~HTML.squeeze(" ").delete("\n").strip
        <video src="https://example.io/demo.mp4"
               poster="https://example.io/poster.png"
               id="test"
               class="test"
               controls=""
               height="10"
               width="10">
          "Unsupported browser."
        </video>
      HTML

      expect(sanitizer.call(video)).to eq(video)
    end
  end
end
