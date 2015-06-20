module Jskit
  # @private
  module Generators
    # @private
    class Base < ::Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)
    end
  end
end
