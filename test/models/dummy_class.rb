class DummyClass
  include Cachely
  cachely :test_function_num, time: 3.minutes
  
  attr_accessor :random_no
  
  #cachely :test_function_array, time: 2.minutes
  #cachely :test_function_hash, time: 2.minutes
  #cachely :test_function_string, time: 3.minutes
  #cachely :test_function_obj, time: 4.minutes
  #cachely :test_function_array_obj, time: 5.minutes
  #cachely :test_function_hash_obj, time: 6.minutes

  def to_json
    {
      "random_no" => self.random_no
    }.to_json
  end
  
  def instance_fixnum
    rand(500)
  end
  
  def instance_fixnum(a)
    rand(500)
  end
  
  def instance_fixnum(a,b)
    rand(500)
  end
  
  def instance_float
    rand(500).to_f + 0.5
  end
  
  def instance_float(a)
    rand(500).to_f + 0.5
  end
  
  def instance_float(a,b)
    rand(500).to_f + 0.5
  end
  
  def instance_string
    rand(500).to_s + "cheese"
  end
  
  def instance_string(a)
    rand(500).to_s + "cheese"
  end
  
  def instance_string(a,b)
    rand(500).to_s + "cheese"
  end
  
  def instance_symbol
    "cheese#{rand(500)}".to_sym
  end
  
  def instance_symbol(a)
    "cheese#{rand(500)}".to_sym
  end
  
  def instance_symbol(a,b)
    "cheese#{rand(500)}".to_sym
  end
  
  def instance_nil #force it to be nil ONLY once to check caching ability.
    p "i am false now " if @@set_nil_0
    return "1" if @@set_nil_0
    @@set_nil_0 = true
    nil
  end
  
  def instance_nil(a)
    p "i am false now " if @@set_nil_1
    return "1" if @@set_nil_1
    @@set_nil_1 = true
    nil  end
  
  def instance_nil(a,b)
    p "i am false now " if @@set_nil_2
    return "1" if @@set_nil_2
    @@set_nil_2 = true
    nil  
  end
  
  def instance_falseclass
    return true if @@set_falseclass_0
    @@set_falseclass_0 = true
    false
  end
  
  def instance_falseclass(a)
    return true if @@set_falseclass_1
    @@set_falseclass_1 = true
    false  
  end
  
  def instance_falseclass(a,b)
    return true if @@set_falseclass_2
    @@set_falseclass_2 = true
    false  
  end
  
  def instance_trueclass
    return false if @@set_trueclass_0
    @@set_trueclass_0 = true
    true
  end
  
  def instance_trueclass(a)
    return false if @@set_trueclass_1
    @@set_trueclass_1 = true
    true  
  end
  
  def instance_trueclass(a,b)
    return false if @@set_trueclass_2
    @@set_trueclass_2 = true
    true  
  end
  
  def instance_orm
    DummyModel.create!(:attr_1 => rand(500), :attr_2 => rand(500))
  end
  
  def instance_orm(a)
    DummyModel.create!(:attr_1 => rand(500), :attr_2 => rand(500))
  end
  
  def instance_orm(a,b)
    DummyModel.create!(:attr_1 => rand(500), :attr_2 => rand(500))
  end
  
  def instance_to_json
    DummyClass
  end
  
  def instance_to_json(a)
    DummyClass
  end
  
  def instance_to_json(a,b)
    DummyClass
  end
  
  def instance_hash
    {:foo => rand(500)}
  end
  
  def instance_hash(a)
    {:foo => rand(500)}
  end
  
  def instance_hash(a,b)
    {:foo => rand(500)}
  end
  
  def instance_array
    [rand(500)]
  end
  
  def instance_array(a)
    [rand(500)]
  end
  
  def instance_array(a,b)
    [rand(500)]
  end
  
  def self.class_fixnum
    rand(500)
  end
  
  def self.class_fixnum(a)
    rand(500)
  end
  
  def self.class_fixnum(a,b)
    rand(500)
  end
  
  def self.class_float
    rand(500).to_f + 0.5
  end
  
  def self.class_float(a)
    rand(500).to_f + 0.5
  end
  
  def self.class_float(a,b)
    rand(500).to_f + 0.5
  end
  
  def self.class_string
    rand(500).to_s + "cheese"
  end
  
  def self.class_string(a)
    rand(500).to_s + "cheese"
  end
  
  def self.class_string(a,b)
    rand(500).to_s + "cheese"
  end
  
  def self.class_symbol
    "cheese#{rand(500)}".to_sym
  end
  
  def self.class_symbol(a)
    "cheese#{rand(500)}".to_sym
  end
  
  def self.class_symbol(a,b)
    "cheese#{rand(500)}".to_sym
  end
  
  def self.class_nil #force it to be nil ONLY once to check caching ability.
    p "i am false now " if @@set_nil_0
    return "1" if @@set_nil_0
    @@set_nil_0 = true
    nil
  end
  
  def self.class_nil(a)
    p "i am false now " if @@set_nil_1
    return "1" if @@set_nil_1
    @@set_nil_1 = true
    nil  end
  
  def self.class_nil(a,b)
    p "i am false now " if @@set_nil_2
    return "1" if @@set_nil_2
    @@set_nil_2 = true
    nil  
  end
  
  def self.class_falseclass
    return true if @@set_falseclass_0
    @@set_falseclass_0 = true
    false
  end
  
  def self.class_falseclass(a)
    return true if @@set_falseclass_1
    @@set_falseclass_1 = true
    false  
  end
  
  def self.class_falseclass(a,b)
    return true if @@set_falseclass_2
    @@set_falseclass_2 = true
    false  
  end
  
  def self.class_trueclass
    return false if @@set_trueclass_0
    @@set_trueclass_0 = true
    true
  end
  
  def self.class_trueclass(a)
    return false if @@set_trueclass_1
    @@set_trueclass_1 = true
    true  
  end
  
  def self.class_trueclass(a,b)
    return false if @@set_trueclass_2
    @@set_trueclass_2 = true
    true  
  end
  
  def self.class_orm
    DummyModel.create!(:attr_1 => rand(500), :attr_2 => rand(500))
  end
  
  def self.class_orm(a)
    DummyModel.create!(:attr_1 => rand(500), :attr_2 => rand(500))
  end
  
  def self.class_orm(a,b)
    DummyModel.create!(:attr_1 => rand(500), :attr_2 => rand(500))
  end
  
  def self.class_to_json
    DummyClass
  end
  
  def self.class_to_json(a)
    DummyClass
  end
  
  def self.class_to_json(a,b)
    DummyClass
  end
  
  def self.class_hash
    {:foo => rand(500)}
  end
  
  def self.class_hash(a)
    {:foo => rand(500)}
  end
  
  def self.class_hash(a,b)
    {:foo => rand(500)}
  end
  
  def self.class_array
    [rand(500)]
  end
  
  def self.class_array(a)
    [rand(500)]
  end
  
  def self.class_array(a,b)
    [rand(500)]
  end
  
end
