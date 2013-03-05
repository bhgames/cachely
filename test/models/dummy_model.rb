class DummyModel < ActiveRecord::Base
  include Cachely
  cachely :use_attributes

  attr_accessible :attr_1, :attr_2, :dummy_model_id
  
  belongs_to :dummy_model, :foreign_key => :dummy_model_id
  
  def instance_fixnum
    rand(500)
  end
  
  def use_attributes
    rand(500)/self.attr_1.to_i # if attr_1 is nil, this thing will throw a ZeroDivisionError. ;)
  end
end
