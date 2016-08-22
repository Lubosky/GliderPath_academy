class FakeSubscription < Hash
  def id
    FactoryGirl.generate(:uuid)
  end

  def save
  end

  def plan=(plan)
    self[:plan] = plan
  end

  def plan
    self[:plan]
  end
end
