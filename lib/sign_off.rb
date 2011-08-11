module SignOff
  def self.included(base)
    base.instance_eval do
      belongs_to :signed_off_by, :class_name => 'User'
    end
  end
  
  def signed_off_toggle
    false
  end
    
  def signed_off_toggle=(yes)
    (yes == '1' || yes == true ) ? sign : unsign
  end
  
  def sign_off_status
    return :notSignedOff unless signed_off_by
    return :oldSignOff unless signed_off_at > 3.months.ago
    return :signedOff
  end
  
  def sign
    self.signed_off_by = user
    self.signed_off_at = Time.now
  end
  
  def unsign
    self.signed_off_by = nil
    self.signed_off_at = nil    
  end
  
end