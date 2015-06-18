module RailsJskit
  class Engine < ::Rails::Engine
    isolate_namespace RailsJskit
    config.to_prepare do
      decorators_path = File.join(RailsJskit::Engine.config.root, "app", "decorators", "**", "rails_jskit", "**", "*_decorator.rb")
      Dir.glob(decorators_path).each do |decorator|
        require_dependency(decorator)
      end
    end
  end
end
