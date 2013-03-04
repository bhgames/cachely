require_relative 'base_test.rb'
#Only do conversions testing here. Test recursivity.
class ConversionsTest < BaseTest
  test "hash conversion" do
    str = Cachely::Mechanics.map_param_to_s({:foo => "bar", :baz => { "nada" => :pink }})
    reformed = Cachely::Mechanics.map_s_to_param(str)
    assert_equal("bar", reformed[:foo])
    assert(reformed[:baz].is_a?(Hash))
    internal = reformed[:baz]
    assert_equal(:pink, internal["nada"])
    assert_equal(2, reformed.keys.size)
    assert_equal(1, internal.keys.size)
  end
  
  test "hash conversion with an array subkey" do
    str = Cachely::Mechanics.map_param_to_s({
      :method => :foo,
      :args => [3,4]
    })
    reformed = Cachely::Mechanics.map_s_to_param(str)
    assert_equal(2, reformed.keys.size)
    assert_equal(:foo, reformed[:method])
    assert_equal(0, [3,4] <=> reformed[:args])
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

  test "orm class" do
    assert_nothing_raised(Exception) do
      Cachely::Mechanics.map_param_to_s(DummyModel)
    end
  end

  test "orm obj referencing itself" do
    d = DummyModel.create!(:attr_1 => rand(500), :attr_2 => rand(500))

    d.dummy_model = d
    d.save!
    assert_nothing_raised(Exception) do
      Cachely::Mechanics.map_param_to_s(d)
    end
  end

  test "orm obj referencing another orm" do
    d = DummyModel.create!(:attr_1 => rand(500), :attr_2 => rand(500))    
    d2 = DummyModel.create!(:attr_1 => rand(500), :attr_2 => rand(500))

    d.dummy_model = d2
    d.save!
    assert_nothing_raised(Exception) do
      Cachely::Mechanics.map_param_to_s(d)
    end
  end

  test "to_json obj referencing itself" do
    d = DummyClass2.new
    assert_nothing_raised(Exception) do
      Cachely::Mechanics.map_param_to_s(d)
    end
  end

  test "array obj referencing itself" do
    arr=[]
    arr<<arr
    assert_nothing_raised(Exception) do
      Cachely::Mechanics.map_param_to_s(arr)
    end
  end

  test "hash obj referencing itself" do
    hash = {}
    hash[:hash] = hash
    assert_nothing_raised(Exception) do
      Cachely::Mechanics.map_param_to_s(hash)
    end
  end

  test "class conversion" do
    str = Cachely::Mechanics.map_param_to_s(DummyClass)
    reformed = Cachely::Mechanics.map_s_to_param(str)
    assert_equal(reformed, DummyClass)
  end
  
  test "orm conversion" do
    d = DummyModel.create!(:attr_1 => rand(500), :attr_2 => rand(500))
    str = Cachely::Mechanics.map_param_to_s(d)
    reformed = Cachely::Mechanics.map_s_to_param(str)
    assert_equal(d.attr_1, reformed.attr_1)
    assert_equal(d.attr_2, reformed.attr_2)
    assert_equal(d.id, reformed.id)
  end
  
  test "primitives conversion" do
    assert_equal("instance|TrueClass|true", Cachely::Mechanics.map_param_to_s(true))
    assert_equal("instance|FalseClass|false", Cachely::Mechanics.map_param_to_s(false))
    assert_equal("instance|Fixnum|1", Cachely::Mechanics.map_param_to_s(1))
    assert_equal("instance|Float|1.1", Cachely::Mechanics.map_param_to_s(1.1))
    assert_equal("instance|String|1", Cachely::Mechanics.map_param_to_s("1"))   
    assert_equal("instance|NilClass|nil", Cachely::Mechanics.map_param_to_s(nil))    
    assert_equal("instance|Symbol|shit", Cachely::Mechanics.map_param_to_s(:shit))    
    assert_equal(true, Cachely::Mechanics.map_s_to_param("instance|TrueClass|true"))
    assert_equal(false, Cachely::Mechanics.map_s_to_param("instance|FalseClass|false"))
    assert_equal(1, Cachely::Mechanics.map_s_to_param("instance|Fixnum|1"))
    assert_equal(1.1, Cachely::Mechanics.map_s_to_param("instance|Float|1.1"))
    assert_equal("1", Cachely::Mechanics.map_s_to_param("instance|String|1"))
    assert_equal("1|2", Cachely::Mechanics.map_s_to_param("instance|String|1|2"))
    assert_equal(:shit, Cachely::Mechanics.map_s_to_param("instance|Symbol|shit"))
    assert_equal(nil, Cachely::Mechanics.map_s_to_param("instance|NilClass|nil"))
    
  end
end
