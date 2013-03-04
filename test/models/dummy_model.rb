class DummyModel < ActiveRecord::Base
  attr_accessible :attr_1, :attr_2
  
  def instance_fixnum
    rand(500)
  end
end
