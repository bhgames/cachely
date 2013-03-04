require "rubygems"
require "bundler"
Bundler.require(:default, :test)
require 'yaml'
base_dir = File.expand_path(File.join(File.dirname(__FILE__), "../.."))
require base_dir + "/lib/cachely.rb"

database_config ||= YAML.load(File.open(File.dirname(__FILE__)+'/../../config/database.yml', 'r'))
ActiveRecord::Base.configurations = database_config
ActiveRecord::Base.establish_connection("test")
conf =  YAML.load(File.read('./config/redis.yml'))
Cachely::Mechanics.connect(conf["test"])

require_relative '../models/dummy_model.rb'
require_relative '../models/dummy_model_two.rb'
require_relative '../models/dummy_class.rb'
require_relative '../models/dummy_class_2.rb'

class BaseTest < ActiveSupport::TestCase
  def setup
    Cachely::Mechanics.flush_all_keys
    DummyModel.destroy_all
  end
end
