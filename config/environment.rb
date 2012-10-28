# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Tanc::Application.initialize!

ActionMailer::Base.smtp_settings = {
  :address => "smtp.tanc.herokuapp.com",
  :port => 25, 
  :user_name =>"stevn1202@gmail.com",
  :password => "kilimchoi",
  :authentication => :login
}
Tanc::Application.configure do 
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.raise_delivery_errors = true
end
