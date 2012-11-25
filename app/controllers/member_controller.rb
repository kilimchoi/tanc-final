class MemberController < ApplicationController
  def signup
    if email_params_has_value and email_format_is_correct then
        new_member = can_create_new_member
        if new_member
           send_new_member_activation_email(new_member) and redirect_to("/member/thanks")
        else 
           flash[:error] = "Your account could not be created because you already signed up." 
           redirect_to("/member/signup")
        end
    end
  end
  
  def reset_password
    if email_params_has_value then 
    	member = Member.find_by_email(params[:email])
    	member.send_reset_password if member
        redirect_to "/member/reset_email_sent"
    end 
  end

  def reset_email_sent
    if email_params_has_value then
       redirect_to "/member/update_password?email=#{params[:email]}"
    end
  end 
    
  def update_password
        @member = Member.find_by_email(params[:email]) rescue nil
        if params[:password] == params[:password_confirm] && params[:commit] == "Update Password"
           @member.update_attributes(:password => params[:password])
           redirect_to "/member/reset_success"
        
        end
  end
  
  
  # helper to dry out code: returns true if :email parameter exists
  def email_params_has_value
     if params[:email] then return true 
     else return false
     end
  end

  # helper to dry out code: returns true if email is in right format
  def email_format_is_correct
     if params[:email] =~ /^[a-z0-9_\+-]+(\.[a-z0-9_\+-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.([a-z]{2,4})$/
       return true
     else 
       return false
     end
  end
    
  def send_new_member_activation_email(new_member)
     new_member.send_activation_email
  end

  def this_user_exists(thisUser)
     if !thisUser.nil?
        return true
     else 
        return false
     end
  end

  # helper to create a new member and dry out code + readability
  def can_create_new_member
      thisUser = Member.find_by_email(params[:email])
      if this_user_exists(thisUser)
         return false
      elsif this_member = Member.create(:email => params[:email], :status => "Pending", :member_type => "Mailing list", 
				     :password => Member.random_password) then return this_member
      end
  end    

  def confirm_account
    if email_params_has_value and code_params_has_value then    
      thisUser = Member.find_by_email(params[:email])
      if this_user_exists_and_temp_pwd_verified(thisUser)
        store_email_in_session(thisUser) and redirect_to("/member/account_setup")
      else
        flash[:error] = "You already created an account with this email."
        redirect_to("/member/")
      end
    end
  end

  # helper to dry out code: returns true if :code parameter exists
  def code_params_has_value
     if params[:code] then return true 
     else return false
     end
  end

  def this_user_exists_and_temp_pwd_verified(aUser)
     if aUser and aUser.confirm(params[:code])
       return true
     else 
       return false
     end
  end
  
  def store_email_in_session(aUser)
     session[:user_email] = aUser.email
  end

  def account_setup
    thisUser = Member.find_by_email(session[:user_email]) rescue nil
    @email = thisUser.email rescue nil    
    if params[:commit] == "Continue"
      if thisUser and thisUser.update_password(params[:password], params["confirm-password"])
        if params[:membership] == "tibetan" || params[:membership] == "spouseoftibetan"
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
        redirect_to("/member/member_payment")
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
      thisUser = find_user_by_email(params[:email]) rescue nil
      if user_exists_valid(thisUser)  
	session[:user_email] = thisUser.email rescue nil
        redirect_to("/member/profile")        
      else
        @email = params[:email]
        flash[:error] = "Your login information is not correct."
        render("index")
      end
    end
  end
  
  def find_user_by_email(email)
    return Member.find_by_email(email)
  end
 
  def user_exists_valid(thisUser)
     return (thisUser and thisUser.authenticate(params[:password]))
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
    if params["commit"] == "Check or Cash"
       redirect_to("/member/check_cash_payment")
    elsif params["commit"] == "Not Paying!"
       redirect_to("/member/thanks_after_done")
    end
  end
  
  def check_cash_payment
    if params["commit"] == "Done!"
       redirect_to("/member/thanks_after_done")
    end
  end
  def admin
    # check if the admin is loaded
    # if not admin, redirect to their own profile
    
    @member_list = []
  end
end
