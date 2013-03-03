require_relative 'base_test.rb'
#This test level is for functionality that occurs at the cachely.rb level. Things that interact
#With the model.
class CachelyTest < BaseTest
  #later test: having defaults in parameters.
  test "caches output of instance and class methods primitive" do
    ["instance","class"].each do |preset|
      [
        "fixnum", 
        "float", 
        "string", 
        "symbol", 
        "nilclass", 
        "trueclass", 
        "falseclass"
      ].each do |type|
        obj = (preset == "class" ? DummyClass : DummyClass.new)
        assert_equal(obj.send(preset+ "_" + type), obj.send(preset + "_" + type))  
        assert_equal(obj.send(preset+ "_" + type+"_one",3), obj.send(preset+ "_" + type + "_one",3))   
        assert_equal(obj.send(preset+ "_" + type+"_two",3,4), obj.send(preset+ "_" + type + "_two",3,4))   
        if(!["nilclass", "trueclass", "falseclass"].include?(type)) #always will be nil/false/true the way we set up tests.
          assert_not_equal(obj.send(preset+ "_" + type+"_two",3,5), obj.send(preset+ "_" + type + "_two",3,4))   
        end
      end 
    end
  end
  
  test "caches output of instance and class methods orm" do
    ["instance","class"].each do |preset|
      obj = preset == "class" ? DummyClass : DummyClass.new
      assert_equal(obj.send(preset+ "_orm").id, obj.send(preset + "_orm").id)  
      assert_equal(obj.send(preset+ "_orm_one",3).id, obj.send(preset+ "_orm_one" ,3).id)   
      assert_equal(obj.send(preset+ "_orm_two",3,4).id, obj.send(preset+ "_orm_two",3,4).id)   
      assert_not_equal(obj.send(preset+ "_orm_two",3,5).id, obj.send(preset+ "_orm_two",3,4).id)
    end
  end
  
  test "caches output of instance and class methods hash" do
    ["instance","class"].each do |preset|
      obj = preset == "class" ? DummyClass : DummyClass.new
      get_back = obj.send(preset+ "_hash")
      get_back_2 = obj.send(preset+ "_hash")
      assert_equal(get_back.keys.size, get_back_2.keys.size)
      assert_equal(get_back[:foo], get_back_2[:foo])
      
      get_back = obj.send(preset+ "_hash_one",3)
      get_back_2 = obj.send(preset+ "_hash_one",3)
      assert_equal(get_back.keys.size, get_back_2.keys.size)
      assert_equal(get_back[:foo], get_back_2[:foo])
      
      get_back = obj.send(preset+ "_hash_two",3,4)
      get_back_2 = obj.send(preset+ "_hash_two",3,4)
      assert_equal(get_back.keys.size, get_back_2.keys.size)
      assert_equal(get_back[:foo], get_back_2[:foo])
      
      get_back = obj.send(preset+ "_hash_two",3,5)
      get_back_2 = obj.send(preset+ "_hash_two",3,4)
      assert_equal(get_back.keys.size, get_back_2.keys.size)
      assert_not_equal(get_back[:foo], get_back_2[:foo])
    end
  end
  
  test "caches output of instance and class methods array" do
    ["instance","class"].each do |preset|
      obj = preset == "class" ? DummyClass : DummyClass.new
      get_back = obj.send(preset+ "_array")
      get_back_2 = obj.send(preset+ "_array")
      assert_equal(0, get_back <=> get_back_2)
      
      get_back = obj.send(preset+ "_array_one",3)
      get_back_2 = obj.send(preset+ "_array_one",3)
      assert_equal(0, get_back <=> get_back_2)
      
      get_back = obj.send(preset+ "_array_two",3,4)
      get_back_2 = obj.send(preset+ "_array_two",3,4)
      assert_equal(0, get_back <=> get_back_2)
      
      get_back = obj.send(preset+ "_array_two",3,5)
      get_back_2 = obj.send(preset+ "_array_two",3,4)
      assert_not_equal(0, get_back <=> get_back_2)
    end
  end
  
  test "caches output of instance and class methods to_json" do
    ["instance","class"].each do |preset|
      obj = preset == "class" ? DummyClass : DummyClass.new
      get_back = obj.send(preset+ "_to_json")
      get_back_2 = obj.send(preset+ "_to_json")
      assert_equal(get_back.random_no, get_back_2.random_no)
      
      get_back = obj.send(preset+ "_to_json_one",3)
      get_back_2 = obj.send(preset+ "_to_json_one",3)
      assert_equal(get_back.random_no, get_back_2.random_no)
      
      get_back = obj.send(preset+ "_to_json_two",3,4)
      get_back_2 = obj.send(preset+ "_to_json_two",3,4)
      assert_equal(get_back.random_no, get_back_2.random_no)
      
      get_back = obj.send(preset+ "_to_json_two",3,5)
      get_back_2 = obj.send(preset+ "_to_json_two",3,4)
      assert_equal(get_back.random_no, get_back_2.random_no)
    end
  end
  
  test "updated object in argument triggers cache refill" do
    #an updated object means logic inside might react differently. SO we need to not get it.
    ["instance","class"].each do |preset|
      obj = preset == "class" ? DummyClass : DummyClass.new
        d = DummyObject.create!(:attr_1 => rand(500), :attr_2 => rand(500))
        get_back = obj.send(preset+"_fixnum_one", d)
        d.attr_1 +=1
        old_time = d.updated_at
        d.save!
        assert_not_equal(old_time, d.updated_at) #just making sure it overwrote it correctly.
        
        get_back_2 = obj.send(preset+"_fixnum_one", d)
        assert_not_equal(get_back, get_back_2) #because orm changed.
    end
  end
  
end
