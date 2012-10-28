class Member < ActiveRecord::Base
  attr_accessible :email, :password, :status, :type
  validates :email, presence: true, uniqueness: true, format: {with: /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i}

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
    if password == verify
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
      :telephone => self.telephone
    }
    return data
  end
end
