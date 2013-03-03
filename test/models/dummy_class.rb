class DummyClass
  include Cachely
  attr_accessor :random_no
  
  cachely :instance_fixnum, time: 3.minutes
  cachely :instance_fixnum_one, time: 3.minutes
  cachely :instance_fixnum_two, time: 3.minutes
  
  cachely :instance_float, time: 3.minutes
  cachely :instance_float_one, time: 3.minutes
  cachely :instance_float_two, time: 3.minutes
  
  cachely :instance_string, time: 3.minutes
  cachely :instance_string_one, time: 3.minutes
  cachely :instance_string_two, time: 3.minutes
  
  cachely :instance_symbol, time: 3.minutes
  cachely :instance_symbol_one, time: 3.minutes
  cachely :instance_symbol_two, time: 3.minutes
  
  cachely :instance_nilclass, time: 3.minutes
  cachely :instance_nilclass_one, time: 3.minutes
  cachely :instance_nilclass_two, time: 3.minutes
  
  cachely :instance_falseclass, time: 3.minutes
  cachely :instance_falseclass_one, time: 3.minutes
  cachely :instance_falseclass_two, time: 3.minutes
  
  cachely :instance_trueclass, time: 3.minutes
  cachely :instance_trueclass_one, time: 3.minutes
  cachely :instance_trueclass_two, time: 3.minutes
  
  cachely :instance_orm, time: 3.minutes
  cachely :instance_orm_one, time: 3.minutes
  cachely :instance_orm_two, time: 3.minutes
  
  cachely :instance_array, time: 3.minutes
  cachely :instance_array_one, time: 3.minutes
  cachely :instance_array_two, time: 3.minutes
  
  cachely :instance_hash, time: 3.minutes
  cachely :instance_hash_one, time: 3.minutes
  cachely :instance_hash_two, time: 3.minutes
  
  cachely :instance_to_json, time: 3.minutes
  cachely :instance_to_json_one, time: 3.minutes
  cachely :instance_to_json_two, time: 3.minutes
  
  cachely :class_fixnum, time: 3.minutes, :class_method => true
  cachely :class_fixnum_one, time: 3.minutes, :class_method => true
  cachely :class_fixnum_two, time: 3.minutes, :class_method => true
  
  cachely :class_float, time: 3.minutes, :class_method => true
  cachely :class_float_one, time: 3.minutes, :class_method => true
  cachely :class_float_two, time: 3.minutes, :class_method => true
  
  cachely :class_string, time: 3.minutes, :class_method => true
  cachely :class_string_one, time: 3.minutes, :class_method => true
  cachely :class_string_two, time: 3.minutes, :class_method => true
  
  cachely :class_symbol, time: 3.minutes, :class_method => true
  cachely :class_symbol_one, time: 3.minutes, :class_method => true
  cachely :class_symbol_two, time: 3.minutes, :class_method => true
  
  cachely :class_nilclass, time: 3.minutes, :class_method => true
  cachely :class_nilclass_one, time: 3.minutes, :class_method => true
  cachely :class_nilclass_two, time: 3.minutes, :class_method => true
  
  cachely :class_falseclass, time: 3.minutes, :class_method => true
  cachely :class_falseclass_one, time: 3.minutes, :class_method => true
  cachely :class_falseclass_two, time: 3.minutes, :class_method => true
  
  cachely :class_trueclass, time: 3.minutes, :class_method => true
  cachely :class_trueclass_one, time: 3.minutes, :class_method => true
  cachely :class_trueclass_two, time: 3.minutes, :class_method => true
  
  cachely :class_orm, time: 3.minutes, :class_method => true
  cachely :class_orm_one, time: 3.minutes, :class_method => true
  cachely :class_orm_two, time: 3.minutes, :class_method => true
  
  cachely :class_array, time: 3.minutes, :class_method => true
  cachely :class_array_one, time: 3.minutes, :class_method => true
  cachely :class_array_two, time: 3.minutes, :class_method => true
  
  cachely :class_hash, time: 3.minutes, :class_method => true
  cachely :class_hash_one, time: 3.minutes, :class_method => true
  cachely :class_hash_two, time: 3.minutes, :class_method => true
  
  cachely :class_to_json, time: 3.minutes, :class_method => true
  cachely :class_to_json_one, time: 3.minutes, :class_method => true
  cachely :class_to_json_two, time: 3.minutes, :class_method => true
  
  def to_json
    {
      "random_no" => self.random_no
    }.to_json
  end
  
  def instance_fixnum
    rand(500)
  end
  
  def instance_fixnum_one(a)
    rand(500)
  end
  
  def instance_fixnum_two(a,b)
    rand(500)
  end
  
  def instance_float
    rand(500).to_f + 0.5
  end
  
  def instance_float_one(a)
    rand(500).to_f + 0.5
  end
  
  def instance_float_two(a,b)
    rand(500).to_f + 0.5
  end
  
  def instance_string
    rand(500).to_s + "cheese"
  end
  
  def instance_string_one(a)
    rand(500).to_s + "cheese"
  end
  
  def instance_string_two(a,b)
    rand(500).to_s + "cheese"
  end
  
  def instance_symbol
    "cheese#{rand(500)}".to_sym
  end
  
  def instance_symbol_one(a)
    "cheese#{rand(500)}".to_sym
  end
  
  def instance_symbol_two(a,b)
    "cheese#{rand(500)}".to_sym
  end
  
  def instance_nilclass #force it to be nil ONLY once to check caching ability.
    @@set_nilclass_0 ||= false
    p "i am false now " if @@set_nilclass_0
    return "1" if @@set_nilclass_0
    @@set_nilclass_0 = true
    nil
  end
  
  def instance_nilclass_one(a)
    @@set_nilclass_1 ||= false
    p "i am false now " if @@set_nilclass_1
    return "1" if @@set_nilclass_1
    @@set_nilclass_1 = true
    nil  end
  
  def instance_nilclass_two(a,b)
    @@set_nilclass_2 ||= false
    p "i am false now " if @@set_nilclass_2
    return "1" if @@set_nilclass_2
    @@set_nilclass_2 = true
    nil  
  end
  
  def instance_falseclass
    @@set_falseclass_0 ||= false
    return true if @@set_falseclass_0
    @@set_falseclass_0 = true
    false
  end
  
  def instance_falseclass_one(a)
    @@set_falseclass_1 ||= false
    return true if @@set_falseclass_1
    @@set_falseclass_1 = true
    false  
  end
  
  def instance_falseclass_two(a,b)
    @@set_falseclass_2 ||= false
    return true if @@set_falseclass_2
    @@set_falseclass_2 = true
    false  
  end
  
  def instance_trueclass
    @@set_trueclass_0 ||= false
    return false if @@set_trueclass_0
    @@set_trueclass_0 = true
    true
  end
  
  def instance_trueclass_one(a)
    @@set_trueclass_1 ||= false
    return false if @@set_trueclass_1
    @@set_trueclass_1 = true
    true  
  end
  
  def instance_trueclass_two(a,b)
    @@set_trueclass_2 ||= false
    return false if @@set_trueclass_2
    @@set_trueclass_2 = true
    true  
  end
  
  def instance_orm
    DummyModel.create!(:attr_1 => rand(500), :attr_2 => rand(500))
  end
  
  def instance_orm_one(a)
    DummyModel.create!(:attr_1 => rand(500), :attr_2 => rand(500))
  end
  
  def instance_orm_two(a,b)
    DummyModel.create!(:attr_1 => rand(500), :attr_2 => rand(500))
  end
  
  def instance_to_json
    DummyClass
  end
  
  def instance_to_json_one(a)
    DummyClass
  end
  
  def instance_to_json_two(a,b)
    DummyClass
  end
  
  def instance_hash
    {:foo => rand(500)}
  end
  
  def instance_hash_one(a)
    {:foo => rand(500)}
  end
  
  def instance_hash_two(a,b)
    {:foo => rand(500)}
  end
  
  def instance_array
    [rand(500)]
  end
  
  def instance_array_one(a)
    [rand(500)]
  end
  
  def instance_array_two(a,b)
    [rand(500)]
  end
  
  def self.class_fixnum
    rand(500)
  end
  
  def self.class_fixnum_one(a)
    rand(500)
  end
  
  def self.class_fixnum_two(a,b)
    rand(500)
  end
  
  def self.class_float
    rand(500).to_f + 0.5
  end
  
  def self.class_float_one(a)
    rand(500).to_f + 0.5
  end
  
  def self.class_float_two(a,b)
    rand(500).to_f + 0.5
  end
  
  def self.class_string
    rand(500).to_s + "cheese"
  end
  
  def self.class_string_one(a)
    rand(500).to_s + "cheese"
  end
  
  def self.class_string_two(a,b)
    rand(500).to_s + "cheese"
  end
  
  def self.class_symbol
    "cheese#{rand(500)}".to_sym
  end
  
  def self.class_symbol_one(a)
    "cheese#{rand(500)}".to_sym
  end
  
  def self.class_symbol_two(a,b)
    "cheese#{rand(500)}".to_sym
  end
  
  def self.class_nilclass #force it to be nil ONLY once to check caching ability.
    @@set_nilclass_0 ||= false
    p "i am false now " if @@set_nilclass_0
    return "1" if @@set_nilclass_0
    @@set_nilclass_0 = true
    nil
  end
  
  def self.class_nilclass_one(a)
    @@set_nilclass_1 ||= false
    p "i am false now " if @@set_nilclass_1
    return "1" if @@set_nilclass_1
    @@set_nilclass_1 = true
    nil  end
  
  def self.class_nilclass_two(a,b)  
    @@set_nilclass_2 ||= false
    p "i am false now " if @@set_nilclass_2
    return "1" if @@set_nilclass_2
    @@set_nilclass_2 = true
    nil  
  end
  
  def self.class_falseclass
    @@set_falseclass_0 ||= false
    return true if @@set_falseclass_0
    @@set_falseclass_0 = true
    false
  end
  
  def self.class_falseclass_one(a)
    @@set_falseclass_1 ||= false
    return true if @@set_falseclass_1
    @@set_falseclass_1 = true
    false  
  end
  
  def self.class_falseclass_two(a,b)
    @@set_falseclass_2 ||= false
    return true if @@set_falseclass_2
    @@set_falseclass_2 = true
    false  
  end
  
  def self.class_trueclass
    @@set_trueclass_0 ||= false
    return false if @@set_trueclass_0
    @@set_trueclass_0 = true
    true
  end
  
  def self.class_trueclass_one(a)
    @@set_trueclass_1 ||= false
    return false if @@set_trueclass_1
    @@set_trueclass_1 = true
    true  
  end
  
  def self.class_trueclass_two(a,b)
    @@set_trueclass_2 ||= false
    return false if @@set_trueclass_2
    @@set_trueclass_2 = true
    true  
  end
  
  def self.class_orm
    DummyModel.create!(:attr_1 => rand(500), :attr_2 => rand(500))
  end
  
  def self.class_orm_one(a)
    DummyModel.create!(:attr_1 => rand(500), :attr_2 => rand(500))
  end
  
  def self.class_orm_two(a,b)
    DummyModel.create!(:attr_1 => rand(500), :attr_2 => rand(500))
  end
  
  def self.class_to_json
    DummyClass
  end
  
  def self.class_to_json_one(a)
    DummyClass
  end
  
  def self.class_to_json_two(a,b)
    DummyClass
  end
  
  def self.class_hash
    {:foo => rand(500)}
  end
  
  def self.class_hash_one(a)
    {:foo => rand(500)}
  end
  
  def self.class_hash_two(a,b)
    {:foo => rand(500)}
  end
  
  def self.class_array
    [rand(500)]
  end
  
  def self.class_array_one(a)
    [rand(500)]
  end
  
  def self.class_array_two(a,b)
    [rand(500)]
  end
end
