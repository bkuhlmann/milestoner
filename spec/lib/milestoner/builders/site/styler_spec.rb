# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Builders::Site::Styler do
  include Dry::Monads[:result]

  using Refinements::Pathname

  subject(:builder) { described_class.new }

  include_context "with application dependencies"

  let(:path) { temp_dir.join "page.css" }

  describe "call" do
    it "builds default path" do
      builder.call
      expect(temp_dir.files).to contain_exactly(path)
    end

    it "builds with relative custom path" do
      settings.stylesheet_path = "test.css"
      builder.call

      expect(temp_dir.files("**/*")).to contain_exactly(temp_dir.join("test.css"))
    end

    it "builds with absolute custom path" do
      settings.stylesheet_path = temp_dir.join "test.css"
      builder.call

      expect(temp_dir.files("**/*")).to contain_exactly(temp_dir.join("test.css"))
    end

    it "answers path" do
      expect(builder.call).to eq(Success(path))
    end

    context "when disabled" do
      before { settings.build_stylesheet = false }

      it "answers empty array" do
        builder.call
        expect(temp_dir.files("**/*")).to eq([])
      end

      it "answers empty success" do
        expect(builder.call).to eq(Success())
      end
    end
  end
end
