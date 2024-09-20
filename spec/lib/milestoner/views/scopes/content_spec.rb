# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Views::Scopes::Content do
  subject(:scope) { described_class.new locals:, rendering: view.new.rendering }

  let :view do
    Class.new Hanami::View do
      config.paths = [Bundler.root.join("lib/milestoner/templates")]
      config.template = "n/a"
    end
  end

  describe "#call" do
    context "with content" do
      let(:locals) { {content: "Test."} }

      it "renders tag signature" do
        expect(scope.call).to eq("Test.\n")
      end
    end

    context "with without content" do
      let(:locals) { Hash.new }

      it "renders tag details" do
        expect(scope.call).to eq(%(<p class="line">None.</p>\n))
      end
    end

    context "with blank content" do
      let(:locals) { {content: ""} }

      it "renders tag details" do
        expect(scope.call).to eq(%(<p class="line">None.</p>\n))
      end
    end
  end
end
