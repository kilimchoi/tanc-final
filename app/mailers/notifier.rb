class Notifier < ActionMailer::Base
  default from: "steven1202@gmail.com"
  def signup_notification(user)
    recipients "#{user.name} <#{user.email}>"
    from "TANC "
    subject "Please Activate your new account"
    sent_on Time.now
    body { :user => user, :url => activate_url(user.activation_code, :host => user.site.host}
    end
end
