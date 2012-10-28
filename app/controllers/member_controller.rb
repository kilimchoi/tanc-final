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

  def login
    if params[:commit] == "Login"
      thisUser = Member.find_by_email(params[:email])
      if thisUser and thisUser.authenticate(params[:password])
        session[:user_email] = thisUser.email
        redirect_to("/member/profile")        
      else
        @email = params[:email]
        flash[:error] = "Your login information is not correct."
        render("index")
      end
    end
  end
  
  def profile
    thisUser = Member.find_by_email(session[:user_email])
    @email = thisUser.email
  end
end
