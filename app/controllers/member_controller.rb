class MemberController < ApplicationController

  def signup

    if email_params_has_value and email_format_is_correct then
      if new_member = can_create_new_member then
	send_new_member_activation_email(new_member) and redirect_to("/member/thanks")
      else 
        flash[:error] = "Your account could not be created" and redirect_to("/member/signup")
      end
    end
  end
  
  def confirm_account
    if email_params_has_value and code_params_has_value then
      this_user = find_user_by_email(params[:email])
      if this_user_exists_and_temporary_password_is_verified(this_user) then
        store_this_user_email_in_current_session(this_user) and redirect_to("/member/account_setup")
      else flash[:error] = "Please click the confirmation link emailed to you" and
           redirect_to("/member/confirm_account")
      end
    end
  end

  def account_setup
    thisUser = Member.find_by_email(session[:user_email]) rescue nil
    @email = thisUser.email  rescue nil 
    if params[:commit] == "Continue"
        if params[:membership] == "member"
          redirect_to("/member/account_setup_member")
        elsif params[:membership] == "non-member"
          redirect_to("/member/profile")
        end
      end
  end
  def account_setup_member
    if user_pressed_continue
      this_user = find_user_by_email(session[:user_email])
      if user_exists_and_info_entered_correctly_and_saved(this_user) then 
        redirect_to("/member/profile")
      else
        flash[:error] = "All fields are required."
      end
    end
  end

  def account_setup_non_member
    if params["commit"] == "Submit"
      thisUser = Member.find_by_email(session[:user_email])
      if thisUser and thisUser.validate_and_update(params)
        redirect_to("/member/profile")
      else
        flash[:error] = "All fields are required."
      end
    end
  end

  def login
    if params[:commit] == "Login"
      thisUser = find_user_by_email(params[:email])
      if user_exists_and_authentication_is_valid
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




def user_exists_and_authentication_is_valid
  return (thisUser and thisUser.authenticate(params[:password]) )
end

 
def send_new_member_activation_email(new_member)
  new_member.send_activation_email
end


# helper to dry out code: returns true if email is in right format
def email_format_is_correct
  if params[:email] =~ /^[a-z0-9_\+-]+(\.[a-z0-9_\+-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.([a-z]{2,4})$/
    return true
  else 
    return false
  end
end

# helper to dry out code: returns true if :email parameter exists
def email_params_has_value
  if params[:email] then return true 
  else return false
  end
end

# helper to dry out code: returns true if :code parameter exists
def code_params_has_value
  if params[:code] then return true 
  else return false
  end
end

# helper to create a new member and dry out code + readability
def can_create_new_member
    if this_member = Member.create(:email => params[:email], :status => "Pending", :member_type => "Mailing list", :password => Member.random_password) then return this_member
    end
end    

def find_user_by_email(email)
  return Member.find_by_email(email)
end

def this_user_exists_and_temporary_password_is_verified(aUser)
  if aUser and aUser.confirm(params[:code])
    return true
  else 
    return false
  end

end

def store_this_user_email_in_current_session(aUser)
  session[:user_email] = aUser.email
end

def user_pressed_continue
  return params[:commit] == "Continue"
end

def user_exists_and_info_entered_correctly_and_saved(aUser)
  return (aUser and aUser.validate_and_update(params) )
end

def user_is_member?
  return params[:membership] == "member"
end
