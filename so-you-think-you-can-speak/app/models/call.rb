class Call < ActiveRecord::Base
  def self.last_calls(delay=60)
    t = Time.now
    where(self.arel_table[:created_at].in(t-delay..t))
  end
  
  def self.count2(delay=120)
    t = Time.now
    where(self.arel_table[:created_at].in(t-delay..t)).count
  end
  
  def self.total
    last_calls.sum('vote')
  end

  def self.data
    lc = last_calls
    value = lc.sum('vote')
    # count = lc.count
    count = count2
    if count == 0
      average_value = 0
    else
      average_value = (100.0*value/count).floor
      average_value >  100 ?  100 : average_value
      average_value < -100 ? -100 : average_value
    end
    { :value => value, :count => count, :average_value => average_value }
  end

end
