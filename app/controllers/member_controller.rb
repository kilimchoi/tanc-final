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
    thisUser = Member.find_by_email(session[:user_email])
    @email = thisUser.email    
    if params[:commit] == "Continue"
      if thisUser.update_password(params[:password], params["confirm-password"])
        if params[:membership] == "member"
          redirect_to("/member/account_setup_member")
        elsif params[:membership] == "non-member"
          redirect_to("/member/account_setup_non_member")
        end
      else
        flash[:error] = "The two password do not match"
      end
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
    if thisUser
      @user_data = thisUser.user_data
    else
      redirect_to("/member/login")
    end
  end
end
