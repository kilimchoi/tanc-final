class IndividualMailer < ActionMailer::Base
  default from: "tanc.herokuapp@gmail.com"

  def activation_notification(member)
    @activate_link = "http://#{ApplicationController.default_url_options[:host]}/member/confirm_account?email=#{member.email}&code=#{member.password}"
    mail(:to => member.email, 
         :subject => "Welcome to TANC",
         :template_path => "emails",
         :template_name => "account_activation"
        )
  end
end
