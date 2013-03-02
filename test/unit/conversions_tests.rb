require_relative 'base_test.rb'
class ConversionsTest < BaseTest
  test "hash conversion" do
    str = Cachely::Mechanics.map_param_to_s({:foo => "bar", :baz => { :nada => :pink }})
    reformed = Cachely::Mechanics.map_s_to_param(str)
    assert_equal("bar", reformed[:foo])
    assert_equal(reformed[:baz].is_a?(Hash))
    internal = reformed[:baz]
    assert_equal(:pink, internal[:nada])
    assert_equal(2, reformed.keys.size)
    assert_equal(1, internal.keys.size)
  end
  
  test "array conversion" do
    str = Cachely::Mechanics.map_param_to_s([1,2,["3","4"]])
    reformed = Cachely::Mechanics.map_s_to_param(str)
    assert_equal(0,[1,2,["3", "4"]] <=> reformed)
  end
  
  test "to_json obj conversion" do
    d = DummyClass.new
    str = Cachely::Mechanics.map_param_to_s(d)
    reformed = Cachely::Mechanics.map_s_to_param(str)
    
    d.
  end
  
  test "orm conversion" do
    fail "not implemented"
  end
  
  test "primitives conversion" do
    fail "not implemented"
  end
end