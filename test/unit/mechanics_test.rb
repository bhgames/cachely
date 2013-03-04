require_relative 'base_test.rb'

#This is for mechanics.rb test that don't have to do with conversions, which are complex enough to 
#have their own file. Test getting/storing, stuff like that.
class MechanicsTest < BaseTest
  test "get/store array" do
    Cachely::Mechanics.store(DummyClass,:foo, [1,2,3], nil, [3,4])
    assert_equal(0, [1,2,3] <=> Cachely::Mechanics.get(DummyClass,:foo, [3,4]).first)
  end
  
  test "get/store hash" do
    Cachely::Mechanics.store(DummyClass,:foo, {:bar => "baz"}, nil, [3,4])
    respawned = Cachely::Mechanics.get(DummyClass,:foo, [3,4]).first
    assert_equal(1, respawned.keys.size)
    assert_equal("baz", respawned[:bar])
  end
  
  test "get/store orm" do
    d = DummyModel.create!(:attr_1 => 1, :attr_2 => 3)
    Cachely::Mechanics.store(DummyClass,:foo, d,nil,[3,4])
    respawned = Cachely::Mechanics.get(DummyClass,:foo, [3,4]).first
    assert_equal(d.id, respawned.id)
    assert_equal(d.attr_1, respawned.attr_1)
    assert_equal(d.attr_2, respawned.attr_2)
  end
  
  test "get/store to_json" do
    d = DummyClass.new
    Cachely::Mechanics.store(DummyClass,:foo, d,nil, [3,4])
    respawned = Cachely::Mechanics.get(DummyClass,:foo, [3,4]).first
    assert_equal(d.random_no, respawned.random_no)
  end
  
  test "get/store primitive" do
    [3, "3", true, false, nil, 3.5, :stuff].each do |result|
      Cachely::Mechanics.store(DummyClass,:foo, result, nil, [3,4])
      respawned = Cachely::Mechanics.get(DummyClass,:foo, [3,4]).first
      assert_equal(result, respawned)
    end
  end
end