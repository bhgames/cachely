require_relative 'base_test.rb'

class CachelyTest < BaseTest
  test "caches output of integer instance method" do
    assert_equal(DummyClass.new.test_function_num, DummyClass.new.test_function_num)   
  end
end
