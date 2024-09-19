# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Views::Scopes::TagSignature do
  subject(:scope) { described_class.new locals:, rendering: view.new.rendering }

  include_context "with enriched tag"

  let :view do
    Class.new Hanami::View do
      config.paths = [Bundler.root.join("lib/milestoner/templates")]
      config.template = "n/a"
    end
  end

  let(:part) { Milestoner::Views::Parts::Tag.new value: tag }

  describe "#tag" do
    context "with locals" do
      let(:locals) { {tag: part} }

      it "answers provided tag" do
        expect(scope.tag).to eq(part)
      end
    end

    context "without locals" do
      let(:locals) { Hash.new }

      it "answers fallback tag" do
        expect(scope.tag).to have_attributes(value: Milestoner::Models::Tag.new)
      end
    end
  end

  describe "#call" do
    context "with secure tag" do
      let(:locals) { {tag: part} }

      it "renders tag signature" do
        expect(scope.call).to eq(<<~CONTENT)
          <button class="button secure" popovertarget="po-tag">
            <span class="signature">🔒 Tag (secure)</span>
          </button>

          <div id="po-tag" class="popover secure" popover="auto">
            <h1 class="label">Version 0.0.0</h1>

            <h2 class="sublabel">SHA</h2>
            <pre>e189297458b52e1be51bfe5237e2d602dad274fa</pre>

            <h2 class="sublabel">Signature</h2>
            <pre>-----BEGIN PGP SIGNATURE-----

          irCY3dRH/SUwJ91y6kf/xPZX/JDZxEDTgRCnb763uh/sYmtv1o42NsCPx4Dllhz7
          ThJRucDpBXYCTm+Fx5j1H/Hct5Xd57CEISXiUcSqLgwhvR2O4/DvLzNDhAQ3ML6x
          -----END PGP SIGNATURE-----
          </pre>
          </div>
        CONTENT
      end
    end

    context "with insecure tag" do
      let(:locals) { Hash.new }

      it "renders tag details" do
        expect(scope.call).to eq(<<~CONTENT)
          <button class="button insecure" popovertarget="po-tag">
            <span class="signature">🔓 Tag (insecure)</span>
          </button>

          <div id="po-tag" class="popover insecure" popover="auto">
            <h1 class="label">Version </h1>
            <p>No signature found.</p>
          </div>
        CONTENT
      end
    end
  end
end
