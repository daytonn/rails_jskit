require "jskit_rails/engine"
require "jskit_rails/configuration"

module JskitRails
  class << self
    attr_accessor :configuration

    def configure(&block)
      fail ArgumentError, "JskitRails#configure requires a block" if block.nil?
      self.configuration = Configuration.new
      block.call(configuration)
    end
  end
end

JskitRails.configuration = JskitRails::Configuration.new
