module Jskit
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def js_manifest
        "app/assets/javascripts/application.js"
      end

      def add_js_to_manifest
        if File.exists? js_manifest
          if has_jquery?
            insert_into_file js_manifest, "//= require lodash\n", before: "//= require jquery\n" unless has_lodash?
          else
            append_to_file js_manifest, "//= require lodash\n//= require jquery\n"
          end
          append_to_file js_manifest, "//= require rails_jskit\n//= require_tree ./controllers\n"
        end
      end

      private

      def has_lodash?
        application_js.match(/\/\/= require lodash/)
      end

      def has_jquery?
        application_js.match(/\/\/= require jquery/)
      end

      def application_js
        @application_js ||= File.read js_manifest
      end
    end
  end
end
