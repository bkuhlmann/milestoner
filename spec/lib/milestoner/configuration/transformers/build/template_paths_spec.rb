# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Configuration::Transformers::Build::TemplatePaths do
  using Refinements::Pathname

  subject(:transformer) { described_class.new }

  describe "#call" do
    it "answers XDG paths plus gem templates path" do
      expect(transformer.call({})).to be_success(
        build_template_paths: [
          Bundler.root.join(".config/milestoner/templates"),
          Pathname("~/.config/milestoner/templates").expand_path,
          Pathname("/etc/xdg/milestoner/templates"),
          Bundler.root.join("lib/milestoner/templates")
        ]
      )
    end
  end
end
