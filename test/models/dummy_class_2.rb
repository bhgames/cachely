class DummyClass2
  
  def to_json
    {
      :me => self.to_json
    }.to_json
  end
end
