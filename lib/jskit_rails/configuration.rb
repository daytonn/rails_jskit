module JskitRails
  class Configuration
    attr_accessor :app_namespace

    def initialize
      self.app_namespace = "App"
    end
  end
end
