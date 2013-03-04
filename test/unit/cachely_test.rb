require_relative 'base_test.rb'
#This test level is for functionality that occurs at the cachely.rb level. Things that interact
#With the model.
class CachelyTest < BaseTest

  test "caches output of methods in orm object" do
    d = DummyModelTwo.create!(:attr_1 => rand(500)) 
    assert_equal(d.i_random, d.i_random)
    assert_equal(DummyModelTwo.random, DummyModelTwo.random)
  end

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
    ["instance"].each do |preset|
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
        d = DummyModel.create!(:attr_1 => rand(500), :attr_2 => rand(500))
        get_back = obj.send(preset+"_fixnum_one", d)
        d.attr_1 +=1
        old_time = d.updated_at
        d.save!
        assert_not_equal(old_time, d.updated_at) #just making sure it overwrote it correctly.
        
        get_back_2 = obj.send(preset+"_fixnum_one", d)
        assert_not_equal(get_back, get_back_2) #because orm changed.
    end
  end
  
  test "instance method called on two diff objects knows its different" do
    obj_1 = DummyModel.create!(:attr_1 => rand(500), :attr_2 => rand(500))
    obj_2 = DummyModel.create!(:attr_1 => rand(500), :attr_2 => rand(500))
    assert_not_equal(obj_1.instance_fixnum, obj_2.instance_fixnum)
  end
  
  test "class method gets cached while normal one does not" do
    obj = DummyClass.new
    klazz = DummyClass
    assert_not_equal(obj.instance_only_cache, klazz.instance_only_cache)
  end
  
  test "diff between class and obj method" do
    obj = DummyClass.new
    klazz = DummyClass
    assert_not_equal(obj.class_diff, klazz.class_diff)
  end
 
  test "cache expires" do
    obj = DummyClass.new
    old = obj.cache_expiry
    sleep(3)
    assert_not_equal(old, obj.cache_expiry)
  end
 
  test "cache with 3 s expiry doesnt expire in 3 s if we keep hitting it" do
    obj = DummyClass.new
    old = obj.cache_expiry_3
    5.times do #should still be present on fourth and fifth times
      sleep(1)
      assert_equal(old, obj.cache_expiry_3)
    end
  
    sleep(4)
    assert_not_equal(old, obj.cache_expiry_3)
  end

end
