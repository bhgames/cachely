require "rubygems"
require "bundler"
Bundler.require(:default, :test)
require 'yaml'
base_dir = File.expand_path(File.join(File.dirname(__FILE__), "../.."))
require base_dir + "/lib/cachely.rb"

class BaseTest < ActiveSupport::TestCase
  def setup
  end
end
