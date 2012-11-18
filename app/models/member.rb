class Member < ActiveRecord::Base
  attr_accessible :email, :password, :status, :type
  validates :email, presence: true, uniqueness: true, format: {with: /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i}

  def self.random_password
    (0...8).map{65.+(rand(26)).chr}.join
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
    data = {
      :id => self.id,
      :type => self.member_type, 
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
      :telephone => self.telephone
    }
    return data
  end

  def validate_and_update(params) 
    if params["address-line-2"] and params["address-line-2"] == ""
      params.delete("address-line-2")
    end
    if params.values.include? ""
      return false
    else
      if params["first-name"]; self.first = params["first-name"]; end;
      if params["last-name"];  self.last = params["last-name"]; end;
      if params["age"]; self.age = params["age"]; end;
      if params["address-line-1"]; self.address1 = params["address-line-1"]; end;
      if params["address-line-2"]; self.address2 = params["address-line-2"]; end;
      if params["city"]; self.city = params["city"]; end;
      if params["Zip"]; self.zip = params["Zip"]; end;
      if params["telephone"]; self.telephone = params["telephone"]; end;
      self.save
      return true
    end
  end

end
