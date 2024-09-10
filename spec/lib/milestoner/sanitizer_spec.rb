# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Sanitizer do
  subject(:sanitizer) { described_class.new }

  describe "#call" do
    it "allows commmon attributes" do
      paragraph = %(<p id="test" class="test">Test.</p>)
      expect(sanitizer.call(paragraph)).to eq(paragraph)
    end

    it "allows a element with attributes" do
      element = %(<a title="Test" href="https://test.io" rel="nofollow">Test.</a>)
      expect(sanitizer.call(element)).to eq(element)
    end

    it "allows audio element with attributes" do
      element = <<~HTML.squeeze(" ").delete("\n").strip
        <audio src="https://test.io/one.flac"
               autoplay="true"
               controls="true"
               controlslist="nodownload"
               crossorigin="anonymous"
               loop="true"
               muted="true"
               preload="auto">
          Unsupported browser.
        </audio>
      HTML

      expect(sanitizer.call(element)).to eq(element)
    end

    it "allows details and summary elements with attributes" do
      element = <<~HTML.squeeze(" ").delete("\n").strip
        <details name="test" open="true">
          <summary>Test</summary>
          A test.
        </details>
      HTML

      expect(sanitizer.call(element)).to eq(element)
    end

    it "allows image element with attributes" do
      element = <<~HTML.squeeze(" ").delete("\n").strip
        <img src="https://test.io/one.png"
             alt="Logo"
             height="10"
             width="10"
             loading="lazy">
      HTML

      expect(sanitizer.call(element)).to eq(element)
    end

    it "allows source element with attributes" do
      source = <<~HTML.squeeze(" ").delete("\n").strip
        <source src="https://test.io/one.png"
                type="image/png"
                srcset="https://test.io/a-tiny.png 10vw, https://test.io/a-small.png 100vw"
                sizes="100vw, 10vw"
                media="(max-width: 600px)"
                height="10"
                width="10">
      HTML

      expect(sanitizer.call(source)).to eq(source)
    end

    it "allows span element" do
      element = "<span>test</span>"
      expect(sanitizer.call(element)).to eq(element)
    end

    it "allows video element with attributes" do
      element = <<~HTML.squeeze(" ").delete("\n").strip
        <video src="https://test.io/one.mp4"
               poster="https://test.io/poster.png"
               controls=""
               height="10"
               width="10">
          Unsupported browser.
        </video>
      HTML

      expect(sanitizer.call(element)).to eq(element)
    end
  end
end
