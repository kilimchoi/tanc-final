class MemberController < ApplicationController
  def signup
    if params[:email] and params[:email] =~ /^[a-z0-9_\+-]+(\.[a-z0-9_\+-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.([a-z]{2,4})$/
      if thisMember = Member.create(:email => params[:email], :status => "Pending", :member_type => "Mailing list", :password => Member.random_password)
        thisMember.send_activation_email
        redirect_to("/member/thanks")
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
        redirect_to("/member/account_setup")
      else
        flash[:error] = "Please click the confirmation link emailed to you"
        redirect_to("/member/confirm_account")
      end
    end
  end

  def account_setup
    thisUser = Member.find_by_email(session[:user_email]) rescue nil
    @email = thisUser.email rescue nil    
    if params[:commit] == "Continue"
      if thisUser and thisUser.update_password(params[:password], params["confirm-password"])
        if params[:membership] == "member"
          redirect_to("/member/account_setup_member")
        elsif params[:membership] == "non-member"
          redirect_to("/member/account_setup_non_member")
        end
      else
        flash[:error] = "The two passwords do not match"
      end
    end
  end

  def account_setup_member
    if params["commit"] == "Continue"
      thisUser = Member.find_by_email(session[:user_email])
      if thisUser and thisUser.validate_and_update(params)
        redirect_to("/member/profile")
      else
        flash[:error] = "All fields are required."
      end 
    end
  end

  def account_setup_non_member
    if params["commit"] == "Submit"
      thisUser = Member.find_by_email(session[:user_email])
      if thisUser.validate_and_update(params)
        redirect_to("/member/profile")
      else
        flash[:error] = "All fields are required."
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

  def member_payment

  end

  def check_cash_payment

  end
end
