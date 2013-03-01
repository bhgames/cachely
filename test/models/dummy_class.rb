class DummyClass
  cachely :test_function_num, :test_function_array, :test_function_hash, :test_function_string, :test_function_obj, :test_function_array_obj, :test_function_hash_obj

  def test_function_num
    rand(500)
  end

  def test_function_not_cached
    rand(500)
  end

  def test_function_array
    [1,2,3,4,5,6, rand(500)]
  end

  def test_function_hash
    {
      :foo => "bar#{rand(500)}"
      :baz => "boof"
    }
  end
  
  def test_function_string
    rand(500).to_s
  end
  
  def id
    5
  end

  def test_function_obj
    
  end
end
