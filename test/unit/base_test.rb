require "rubygems"
require "bundler"
Bundler.require(:default, :test)
require 'yaml'
base_dir = File.expand_path(File.join(File.dirname(__FILE__), "../.."))
require base_dir + "/lib/cachely.rb"
require_relative '../models/dummy_model.rb'
require_relative '../models/dummy_class.rb'

class BaseTest < ActiveSupport::TestCase
  def setup
    database_config ||= YAML.load(File.open(File.dirname(__FILE__)+'/../../config/database.yml', 'r'))
    ActiveRecord::Base.configurations = database_config
    ActiveRecord::Base.establish_connection("test")

    DummyModel.destroy_all
  end
end
