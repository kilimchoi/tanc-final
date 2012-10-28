class MemberController < ApplicationController
  def signup
    if params[:email]
      if Member.create(:email => params[:email], :status => "Pending", :member_type => "Mailing list", :password => "1234")
        redirect_to("/member/confirm_account")
      else 
        flash[:error] = "Your account could not be created"
        redirect_to("/member/signup")
      end
    end
  end
  
  def confirm_account
    if params[:email] and params[:code]
      thisUser = Member.find_by_email(params[:email])
      if thisUser and thisUser.confirm(params[:code])
        session[:user_email] = thisUser.email
        redirect_to("/member/thanks")
      else
        flash[:error] = "Please click the confirmation link emailed to you"
        redirect_to("/member/confirm_account")
      end
    end
  end

  def account_setup
    @email = session[:user_email]      
    if params[:action] == "Save"

    end
  end

  def member_payment

  end

  def check_cash_payment

  end
end
