# frozen_string_literal: true

RSpec.shared_context "with enriched tag" do
  include_context "with enriched commit"

  let :tags do
    [
      Milestoner::Models::Tag[
        author: Milestoner::Models::User[external_id: "1", handle: "mal", name: "Malcolm Reynolds"],
        commits: [commit],
        committed_at: Time.new(2024, 7, 5, 1, 1, 1),
        contributors: [
          Milestoner::Models::User[external_id: "1", handle: "mal", name: "Malcolm Reynolds"]
        ],
        sha: "6c352cce068b11b8f8b4b2078199df6a353c0d1d",
        signature: tag_signature,
        version: "0.1.0"
      ],
      tag
    ]
  end

  let :tag do
    Milestoner::Models::Tag[
      author: Milestoner::Models::User[external_id: "1", handle: "mal", name: "Malcolm Reynolds"],
      commits: [commit],
      committed_at: Time.new(2024, 7, 4, 2, 2, 2),
      contributors: [
        Milestoner::Models::User[external_id: "1", handle: "mal", name: "Malcolm Reynolds"]
      ],
      sha: "e189297458b52e1be51bfe5237e2d602dad274fa",
      signature: tag_signature,
      version: "0.0.0"
    ]
  end

  let :tag_signature do
    <<~BODY
      -----BEGIN PGP SIGNATURE-----

      irCY3dRH/SUwJ91y6kf/xPZX/JDZxEDTgRCnb763uh/sYmtv1o42NsCPx4Dllhz7
      ThJRucDpBXYCTm+Fx5j1H/Hct5Xd57CEISXiUcSqLgwhvR2O4/DvLzNDhAQ3ML6x
      -----END PGP SIGNATURE-----
    BODY
  end
end
