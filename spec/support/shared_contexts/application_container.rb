# frozen_string_literal: true

require "dry/container/stub"

RSpec.shared_context "with application container" do
  let(:container) { Milestoner::Container }
  let(:kernel) { class_spy Kernel }

  before do
    container.enable_stubs!
    container.stub :kernel, kernel
  end

  after { container.unstub :kernel }
end
