class Member < ActiveRecord::Base
  attr_accessible :email, :password, :status, :type
  validates :email, presence: true, uniqueness: true, format: {with: /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i}

  def self.random_password
    (0...8).map{65.+(rand(26)).chr}.join
  end

  def send_reset_password
    self.password_reset_sent_at = Time.zone.now
    save!
    IndividualMailer.reset_password(self).deliver()
  end
  

  def send_activation_email
    email = IndividualMailer.activation_notification(self)
    email.deliver()
  end
  
  def confirm(code)
    if code == self.password
      update_attribute('confirmed', true)
      return true
    else
      return false
    end
  end

  def authenticate(password)
    return self.password == password
  end

  def update_password(password, verify)
    if password == verify and password != ""
      self.password = password
      self.save
      return true
    else
      return false
    end
  end

  def user_data
    data = {:type => self.member_type, 
      :email => self.email, 
      :first => self.first, 
      :last => self.last, 
      :status => self.status,
      :age => self.age,
      :address1 => self.address1,
      :address2 => self.address2,
      :city => self.city,
      :state => self.state,
      :zip => self.zip,
      :telephone => self.telephone,
      :year_of_birth => self.year_of_birth,
      :country_of_birth => self.country_of_birth,
      :occupation => self.occupation
    }
    return data
  end

  def validate_and_update(params)
    right_format = true
    if params["address-line-2"] and params["address-line-2"] == ""
      params.delete("address-line-2")
    end
    if params.values.include? ""
      return false
    else
      if params["first-name"] and params["first-name"] =~ /[A-Za-z]+/; self.first = params["first-name"];
      else
        return false; end;
      if params["last-name"] and params["last-name"] =~ /[A-Za-z]+/; self.last = params["last-name"];
      else
        return false; end;
      if params["address-line-1"] and params["address-line-1"] =~ /\d|[-]|[A-Za-z]+|\s/; self.address1 = params["address-line-1"];
      else
        return false; end;
      if params["address-line-2"]; self.address2 = params["address-line-2"]; end;
      if params["city"] and params["city"] =~ /[A-Za-z]+/; self.city = params["city"];
      else
        return false; end;
      if params["zip"] and params["zip"] =~ /\d{1,10}/; self.zip = params["zip"];
      else
        return false; end;
      if params["state"] and params["state"] =~ /[A-Za-z]+/; self.state = params["state"];
      else
        return false; end;
      if params["telephone"] and params["telephone"] =~ /\d{1,10}|[-]/; self.telephone = params["telephone"];
      else
        return false; end;
      if params["year_of_birth"] and params["year_of_birth"] =~ /\d{1,4}/; self.year_of_birth = params["year_of_birth"];
      else
        return false; end;
      if params["country_of_birth"] and params["country_of_birth"] =~ /[A-Za-z]+/; self.country_of_birth = params["country_of_birth"];
      else
        return false; end;
      if params["occupation"]; self.occupation = params["occupation"]; end;
      if params["gender"]; self.gender = params["gender"]; end;
      self.save
      return true
    end
  end

end
