class DummyModelTwo < ActiveRecord::Base
  include Cachely
  cachely :random
  attr_accessible :attr_1

  def random(arg)
    rand(500)
  end

  def self.random(arg)
    rand(500)
  end
end
