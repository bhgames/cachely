class DummyClass
  include Cachely
  attr_accessor :random_no
  cachely :test_function_num, time: 3.minutes
  #cachely :test_function_array, time: 2.minutes
  #cachely :test_function_hash, time: 2.minutes
  #cachely :test_function_string, time: 3.minutes
  #cachely :test_function_obj, time: 4.minutes
  #cachely :test_function_array_obj, time: 5.minutes
  #cachely :test_function_hash_obj, time: 6.minutes

  def to_json
    {
      "random_no": self.random_no
    }
  end
  
  def test_function_num
    rand(500)
  end

  def self.class_test_function_num
    rand(500)
  end

  def self.class_test_function_not_cached
    rand(500)
  end

  def test_function_not_cached
    rand(500)
  end

  def test_function_array
    [1,2,3,4,5,6, rand(500)]
  end

  def self.class_test_function_array
    [1,2,3,4,5,6, rand(500)]
  end

  def test_function_hash
    {
      :foo => "bar#{rand(500)}",
      :baz => "boof"
    }
  end
 
  def self.class_test_function_hash
    {
      :foo => "bar#{rand(500)}",
      :baz => "boof"
    }
  end 

  def test_function_string
    rand(500).to_s
  end
 
  def self.class_test_function_string
    rand(500).to_s
  end
  
  def test_function_obj
    DummyModel.create(
      :attr1 => rand(500),
      :attr2 => rand(500)
    )    
  end

  def self.class_test_function_obj
    DummyModel.create(
      :attr1 => rand(500),
      :attr2 => rand(500)
    )    
  end

  def test_function_array_obj
    [test_function_obj, test_function_obj]
  end

  def self.class_test_function_array_obj
    [test_function_obj, test_function_obj]
  end

  def test_function_hash_obj
    {
      :foo => test_function_obj,
      :bar => test_function_obj
    }
  end

  def self.class_test_function_hash_obj
    {
      :foo => test_function_obj,
      :bar => test_function_obj
    }
  end
end
