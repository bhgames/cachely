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

  def to_json
    {
      :id => self.id,
      :attr_1 => self.attr_1
    }.to_json
  end
end
