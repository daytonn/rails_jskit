module Jskit
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def create_controllers_directory
        empty_directory "app/assets/javascripts/controllers"
      end

      def copy_controllers
        template "app/assets/javascripts/controllers/application_controller.js"
      end

      def add_js_to_manifest
        add_rails_jskit if manifest?
      end

      def append_jskit_to_application_layout
        send("append_jskit_method_to_application_layout_#{layout_extension}") unless jskit_method_exists?
      end

      def create_initializer
        template "config/initializers/rails_jskit.rb"
      end

      private

      def add_rails_jskit
        return if rails_jskit?
        if require_tree?
          gsub_file(js_manifest, /\/\/= require_tree \./, "//= require rails_jskit\n//= require_tree ./controllers\n")
        else
          append_to_file(js_manifest, "//= require rails_jskit\n//= require_tree ./controllers\n")
        end
      end

      def jskit_method_snippet
        method = case layout_extension
        when :erb
          "<%= jskit %>"
        when :haml
          "= jskit"
        end

        "\n#{body_indentation}#{method}\n"
      end

      def jskit_method_exists?
        !!layout_file_content.match(/\= jskit/)
      end

      def layout_file_content
        File.exists?(layout_file) ? File.read(layout_file) : ""
      end

      def body_indentation
        "#{layout_file_content.match(/^(\s+)%body/)[1]}  "
      end

      def layout_file
        @layout_file ||= Dir["app/views/layouts/application.html*"].first
      end

      def append_jskit_method_to_application_layout_erb
        insert_into_file layout_file, jskit_method_snippet, before: "</body>"
      end

      def append_jskit_method_to_application_layout_haml
        append_to_file layout_file, jskit_method_snippet
      end

      def layout_extension
        File.extname(layout_file).gsub(/^\./, "").to_sym
      end

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

      def application_js
        @application_js ||= File.read js_manifest
      end
    end
  end
end
