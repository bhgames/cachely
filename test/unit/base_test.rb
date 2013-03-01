
base_dir = File.expand_path(File.join(File.dirname(__FILE__), "../.."))

require 'pry'
require 'test/unit'
require 'yaml'
require 'active_support'
require base_dir + "/lib/cachely.rb"

class BaseTest < ActiveSupport::TestCase
  def setup
  end
end
