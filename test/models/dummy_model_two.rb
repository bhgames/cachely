class DummyModelTwo < ActiveRecord::Base
  include Cachely
  attr_accessible :attr_1
  cachely :i_random
  cachely :random
  def i_random
    rand(500)
  end

  def self.random
    rand(500)
  end
end
