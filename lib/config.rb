# frozen_string_literal: true

require 'singleton'
require 'yaml'

class Config
  include Singleton

  attr_reader :default
  attr_accessor :user, :password, :slack_token

  def initialize
    config_file = yaml_file.transform_keys(&:to_sym)
    @default = Struct.new(*config_file.keys).new(*config_file.values)
  end

  private

  def yaml_file
    YAML.load_file('config.yml')
  end
end
