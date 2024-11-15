# frozen_string_literal: true

require "hanami/view"
require "refinements/array"

module Milestoner
  module Views
    module Parts
      # The commit presentation logic.
      # :reek:RepeatedConditional
      class Commit < Hanami::View::Part
        include Dependencies[:settings, :sanitizer, :color]

        using Refinements::Array

        decorate :author, as: :user
        decorate :collaborators, as: :users
        decorate :signers, as: :users

        def initialize(**)
          super
          @prefixes = settings.commit_categories.pluck :label
        end

        def colored_author(*custom)
          custom.push :bold, :blue if custom.empty?
          color[author.name, *custom]
        end

        def colored_created_relative_at(*custom)
          custom.push :bright_purple if custom.empty?
          color[authored_relative_at, *custom]
        end

        def colored_updated_relative_at(*custom)
          custom.push :cyan if custom.empty?
          color[committed_relative_at, *custom]
        end

        def colored_sha(*custom)
          custom.push :yellow if custom.empty?
          color[sha[...12], *custom]
        end

        def created_at_human = created_at.strftime "%Y-%m-%d (%A) %I:%M %p %Z"

        def created_at_machine = created_at.strftime "%Y-%m-%dT%H:%M:%S%z"

        def kind
          if prefixes.include? prefix then "normal"
          elsif directive? then "alert"
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
          elsif directive? then "rebase"
          else "invalid"
          end
        end

        def milestone_emoji
          case milestone
            when "major" then "🔴"
            when "minor" then "🔵"
            when "patch" then "🟢"
            else "⚪️"
          end
        end

        def safe_body = sanitizer.call(body_html).html_safe

        def safe_notes = sanitizer.call(notes_html).html_safe

        def total_deletions = format "%d", -deletions

        # :reek:FeatureEnvy
        def total_insertions
          insertions.then { |total| total.positive? ? "+#{total}" : total.to_s }
        end

        def tag
          return "rebase" if directive?
          return "invalid" unless prefixes.include? prefix

          milestone
        end

        def popover_id = "po-#{sha}"

        def security = signature == "Good" ? "secure" : "insecure"

        def signature_emoji = signature.then { |kind| kind == "Good" ? "🔒" : "🔓" }

        def signature_id = value.fingerprint.then { |text| text.empty? ? "N/A" : text }

        def signature_key = value.fingerprint_key.then { |text| text.empty? ? "N/A" : text }

        def signature_label
          signature.then { |kind| kind == "Good" ? "🔒 #{kind}" : "🔓 #{kind}" }
        end

        def updated_at_human = updated_at.strftime "%Y-%m-%d (%A) %I:%M %p %Z"

        def updated_at_machine = updated_at.strftime "%Y-%m-%dT%H:%M:%S%z"

        private

        attr_reader :prefixes
      end
    end
  end
end
