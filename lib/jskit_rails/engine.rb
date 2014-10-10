module JskitRails
  class Engine < ::Rails::Engine
    isolate_namespace JskitRails
    config.to_prepare do
      decorators_path = File.join(JskitRails::Engine.config.root, "app", "decorators", "**", "jskit_rails", "**", "*_decorator.rb")
      Dir.glob(decorators_path).each do |decorator|
        require_dependency(decorator)
      end
    end
  end
end
