# frozen_string_literal: true

require "hanami/view"
require "refinements/array"

module Milestoner
  module Views
    module Parts
      # The commit presentation logic.
      # :reek:RepeatedConditional
      class Commit < Hanami::View::Part
        include Import[:settings, :sanitizer]

        using Refinements::Array

        decorate :author, as: :user
        decorate :collaborators, as: :users
        decorate :signers, as: :users

        def initialize(**)
          super
          @prefixes = settings.commit_categories.pluck :label
          @authored_at = Time.at value.authored_at.to_i
        end

        def avatar_url user
          warn "`#{self.class}##{__method__}` is deprecated, use user scope instead.",
               category: :deprecated

          format settings.avatar_uri, id: user.external_id
        end

        def profile_url user
          warn "`#{self.class}##{__method__}` is deprecated, use user scope instead.",
               category: :deprecated

          format settings.profile_uri, id: user.handle
        end

        def kind
          if prefixes.include? prefix then "normal"
          elsif value.directive? then "alert"
          else "error"
          end
        end

        def emoji
          settings.commit_categories
                  .find { |category| category.fetch(:label) == prefix }
                  .then { |category| category ? category.fetch(:emoji) : "🔶" }
        end

        def icon
          if prefixes.include? prefix then String(prefix).downcase
          elsif value.directive? then "rebase"
          else "invalid"
          end
        end

        def safe_body = sanitizer.call(value.body).html_safe

        def safe_notes = sanitizer.call(value.notes).html_safe

        def total_deletions = format "%d", -value.deletions

        # :reek:FeatureEnvy
        def total_insertions
          value.insertions.then { |total| total.positive? ? "+#{total}" : total.to_s }
        end

        def tag
          return "rebase" if value.directive?
          return "invalid" unless prefixes.include? prefix

          value.milestone
        end

        def popover_id = "po-#{value.sha}"

        def security = value.signature == "Good" ? "secure" : "insecure"

        def signature_label
          value.signature.then { |kind| kind == "Good" ? "🔒 #{kind}" : "🔓 #{kind}" }
        end

        def fingerprint = value.fingerprint.then { |text| text.empty? ? "N/A" : text }

        def fingerprint_key = value.fingerprint_key.then { |text| text.empty? ? "N/A" : text }

        def at = authored_at.strftime "%Y-%m-%dT%H:%M:%S%z"

        def datetime = authored_at.strftime "%Y-%m-%d (%A) %I:%M %p %Z"

        def weekday = authored_at.strftime "%A"

        def date = authored_at.strftime "%Y-%m-%d"

        def time = authored_at.strftime "%I:%M %p"

        def zone = authored_at.strftime "%Z"

        private

        attr_reader :prefixes, :authored_at

        def prefix = value.prefix
      end
    end
  end
end
