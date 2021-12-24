# frozen_string_literal: true

RSpec.shared_examples "a base error" do
  it "behaves like a base error" do
    expect(error).to be_a(Milestoner::Errors::Base)
  end
end
