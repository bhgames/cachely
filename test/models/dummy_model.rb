class DummyModel < ActiveRecord::Base
  attr_accessible :attr_1, :attr_2, :dummy_model_id
  
  belongs_to :dummy_model, :foreign_key => :dummy_model_id
  
  def instance_fixnum
    rand(500)
  end
end
