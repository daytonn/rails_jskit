require "rails_jskit/engine"
require "rails_jskit/configuration"

module RailsJskit
  class << self
    attr_accessor :configuration

    def configure(&block)
      fail ArgumentError, "RailsJskit#configure requires a block" if block.nil?
      self.configuration = Configuration.new
      block.call(configuration)
    end
  end
end

RailsJskit.configuration = RailsJskit::Configuration.new
