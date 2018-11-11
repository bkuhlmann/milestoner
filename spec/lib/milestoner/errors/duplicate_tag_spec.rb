# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Errors::DuplicateTag do
  it_behaves_like "a base error" do
    let(:error) { described_class.new }
  end
end
