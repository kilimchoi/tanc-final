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
     elsif email_params_has_value and !email_format_is_correct 
	flash.now[:error] = "Please type in correct email address."
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
     if params[:email] =~ /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/
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
      user_by_email = Member.find_by_email(params[:email])
      if this_user_exists(user_by_email)
         return false
      else 
         thisUser = Member.create(:email => params[:email], :status => "Pending", :member_type => "Mailing list", :password => Member.random_password, :admin => false)
         return thisUser
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
  
   def reset_password
    if email_params_has_value and member_email? then
        member = Member.find_by_email(params[:email])
        member.send_reset_password if member
        redirect_to "/member/reset_email_sent"
    elsif email_params_has_value and !email_format_is_correct
        flash.now[:error] = "Please type in correct email address."
    elsif email_params_has_value and !member_email? then
        flash.now[:error] = "You haven't signed up with that email! Please go back to the sign up page."
    end
  end
  
  def member_email?
    @member = Member.find_by_email(params[:email])
    if @member.nil?
       return false
    else
       return true
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

  def account_setup
    thisUser = Member.find_by_email(session[:user_email]) rescue nil
    if (thisUser.id == 1)
	thisUser.admin = true
    else
	(thisUser.admin = false)
    end
    @email = thisUser.email rescue nil
    if params[:commit] == "Continue"
      if thisUser and thisUser.update_password(params[:password], params["confirm-password"])
        if params[:membership] == "tibetan" || params[:membership] == "spouseoftibetan"
           thisUser.member_type = params[:membership]
           thisUser.already_a_member = "No"
           thisUser.save
	   redirect_to("/member/account_setup_member")
        elsif params[:membership] == "non-member" and !thisUser.member_active
           redirect_to("/member/account_setup_non_member")
        else thisUser.member_active
           flash.now[:error] = "Sorry you can't sign up twice!"
        end
      else
        flash.now[:error] = "The two passwords do not match"
      end
    end
  end

  def account_setup_member
    if params["commit"] == "Continue"
      thisUser = Member.find_by_email(session[:user_email])
      if thisUser and thisUser.validate_and_update(params)
        if !thisUser.member_active
           thisUser.member_active = true
 	   thisUser.save
	   redirect_to("/member/member_payment")
        else
           flash.now[:error] = "You already signed up!"
        end
      else
        flash.now[:error] = "Please enter the correct format and fill in all fields are required."
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
  

  def member_payment
    if params["commit"] == "Check or Cash"
       redirect_to("/member/check_cash_payment")
    elsif params["commit"] == "Online Payment"
       redirect_to("/member/online_payment")
    elsif params["commit"] == "Not Paying!"
       redirect_to("/member/thanks_after_done")
    end
  end
  
  def check_cash_payment
    if params["commit"] == "Done!"
       redirect_to("/member/thanks_after_done")
    end
  end

  def online_payment
    if params["commit"] == "Done!"
       redirect_to("/member/thanks_after_done")
    end
  end
  
  
  def profile
    thisUser = find_user_by_email(session[:user_email])
    if thisUser
      @user_data = thisUser.user_data
      if params["commit"] == "logout"
        redirect_to("/member")
	session.delete(:user_email)#clear user data from session
      end
      if params["commit"] == "Edit your Profile"
        redirect_to("member/edit")
      end
      if params["commit"] == "manage database"
        if user.admin == true then redirect_to("/member/admin"); end
      end
    else
	redirect_to("/member/login")
	flash[:error] = "You are not logged in. Please log in and try again."
    end
  end

  def admin
    this_user = find_user_by_email(session[:user_email])
    if this_user # exists
       if (this_user.admin) != true
          redirect_to("/member/profile") #and
	  #flash[:error] = "You are not an admin so you cannot access the admin page"
       else # if you got here, user is admin
          Member.all.each do |user|
             if user.first
                @member_list << user.user_data rescue nil
             end
          end
       end
       if params["commit"] == "logout"
          redirect_to("/member")
	  session.delete(:user_email)#clear user data from session
       end
       if params["commit"] == "Add a new member"
          redirect_to("/member/admin/add_new_member")
       end
       if params["commit"] == "refresh"
          redirect_to("/member/admin")
       end
    else 
	redirect_to("/member")
        flash[:error] = "You are not logged in- please log in first."
    end
  end

  def export
    this_user = find_user_by_email(session[:user_email])
    if this_user and this_user.admin # member is an admin
      filename = 'members.csv'
      ext = File.extname(filename)[1..-1]
      mime = Mime::Type.lookup_by_extension(ext)
      content_type = mime.to_s unless mime.nil?
      @member_list = []
      Member.find(:all).each do |member|
        @member_list << member.user_data
      end
      puts @member_list
      render "csv_export.csv.erb", :content_type => content_type
    end
  end
end
