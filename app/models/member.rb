class Member < ActiveRecord::Base
  attr_accessible :id, :email, :name, :password, :status, :type
  validates :email, presence: true, uniqueness: true, format: {with: /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i}

  def confirm(code)
    if code == self.password
      update_attribute('confirmed', true)
      return true
    else
      return false
    end
  end

  def to_hash
  {
    :email => self.email,
    :name => self.name,
    :status => self.status,
    :password => self.status,
    :type => self.type,
    :id => self.id
  }
  end
end
