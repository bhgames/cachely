require_relative 'base_test.rb'
class ConversionsTest < BaseTest
  test "hash conversion" do
    str = Cachely::Mechanics.map_param_to_s({:foo => "bar", :baz => { "nada" => :pink }})
    reformed = Cachely::Mechanics.map_s_to_param(str)
    assert_equal("bar", reformed[:foo])
    assert_equal(reformed[:baz].is_a?(Hash))
    internal = reformed[:baz]
    assert_equal(:pink, internal["nada"])
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
    d.random_no = rand(500)
    str = Cachely::Mechanics.map_param_to_s(d)
    reformed = Cachely::Mechanics.map_s_to_param(str)
    assert_equal(d.random_no, reformed.random_no)
  end
  
  test "orm conversion" do
    d = DummyModel.create!(:attr1 => rand(500), :attr2 => rand(500))
    str = Cachely::Mechanics.map_param_to_s(d)
    reformed = Cachely::Mechanics.map_s_to_param(str)
    assert_equal(d.attr1, reformed.attr1)
    assert_equal(d.attr2, reformed.attr2)
    assert_equal(d.id, reformed.id)
  end
  
  test "primitives conversion" do
    assert_equal("TrueClass:true", Cachely::Mechanics.map_param_to_s(true))
    assert_equal("FalseClass:false", Cachely::Mechanics.map_param_to_s(false))
    assert_equal("Fixnum:1", Cachely::Mechanics.map_param_to_s(1))
    assert_equal("Float:1.1", Cachely::Mechanics.map_param_to_s(1.1))
    assert_equal("String:1", Cachely::Mechanics.map_param_to_s("1"))   
    assert_equal("NilClass:nil", Cachely::Mechanics.map_param_to_s(nil))    
    assert_equal("Symbol:shit", Cachely::Mechanics.map_param_to_s(:shit))    
    assert_equal(true, Cachely::Mechanics.map_s_to_param("TrueClass:true"))
    assert_equal(false, Cachely::Mechanics.map_s_to_param("FalseClass:false"))
    assert_equal(1, Cachely::Mechanics.map_s_to_param("Fixnum:1"))
    assert_equal(1.1, Cachely::Mechanics.map_s_to_param("Float:1.1"))
    assert_equal("1", Cachely::Mechanics.map_s_to_param("String:1"))
    assert_equal("1:2", Cachely::Mechanics.map_s_to_param("String:1:2"))
    assert_equal(:shit, Cachely::Mechanics.map_s_to_param("Symbol:shit"))
    assert_equal(nil, Cachely::Mechanics.map_s_to_param("NilClass:nil"))
    
  end
end