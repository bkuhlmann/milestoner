# frozen_string_literal: true

module Milestoner
  module Syndication
    # Provides shared functionality for refinements.
    module Shared
      def merge(**attributes) = attributes.each { |key, value| public_send :"#{key}=", value }

      def build_for(collection, **)
        collection.each { |attributes| build(**attributes.transform_keys(**)) }
      end

      def build(**attributes)
        node = public_send :"new_#{kind}"
        attributes.each { |key, value| node.public_send :"#{key}=", value }
      end

      private

      def kind
        self.class.name.downcase.split("::").last.sub("categories", "category").delete_suffix("s")
      end
    end
  end
end
