class MemberController < ApplicationController
  @member = Member.all
  def show
    @member = Member.find params[:id] 
  end

  def edit
    @member = Member.find params[:id]
  end

  def update
    @member = Member.find params[:id]
    @member.update_attributes!(params[:member])
    redirect_to member_path(@member)
  end

  # STEVEN or PETER- I have a button_to delete in show.html.erb. Seems like the button is not calling this destroy method 
  def destroy
    @member = Member.find params[:id] 
    @member.destroy
    #flash[:notice] = "#{@member.first}' deleted."
    redirect_to ("/member/admin")
  end

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
    if verify_recaptcha
       if email_params_has_value and member_email? then
           member = Member.find_by_email(params[:email])
           member.send_reset_password if member
           redirect_to "/member/reset_email_sent"
       elsif email_params_has_value and !email_format_is_correct
           flash.now[:error] = "Please type in correct email address."
       elsif email_params_has_value and !member_email? then
           flash.now[:error] = "You haven't signed up with that email! Please go back to the sign up page."
       end
    else
       flash[:error] = "Your words do not match the ones in the recaptcha image!"
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
    if email_params_has_value and member_email?  then
       member = Member.find_by_email(params[:email])
       if member and member.password == params[:request] then
          redirect_to "/member/update_password?email=#{params[:email]}"
       end
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
         if verify_recaptcha
           if params[:membership] == "tibetan" || params[:membership] == "spouseoftibetan" and !thisUser.member_active and !thisUser.non_member_active
              thisUser.member_type = params[:membership]
              thisUser.already_a_member = "No"
              thisUser.save
	      redirect_to("/member/account_setup_member")
           elsif params[:membership] == "non-member" and !thisUser.member_active and !thisUser.non_member_active
              redirect_to("/member/account_setup_non_member")
           elsif thisUser.member_active || thisUser.non_member_active
              flash.now[:error] = "Sorry you can't sign up twice!"
           end
         else
              flash[:error] = "Your words do not match the ones in the recaptcha image!"
         end
      else
         flash.now[:error] = "The two passwords do not match"
      end
    end
  end

  def account_setup_member
    thisUser = Member.find_by_email(session[:user_email])
    if thisUser
      @first = thisUser.first rescue nil
      @last = thisUser.last rescue nil
      @address1 = thisUser.address1 rescue nil
      @address2 = thisUser.address2 rescue nil
      @city = thisUser.city rescue nil
      @state = thisUser.state rescue nil
      @zip = thisUser.zip rescue nil
      @telephone = thisUser.telephone rescue nil
      @year_of_birth = thisUser.year_of_birth rescue nil
      @country_of_birth = thisUser.country_of_birth rescue nil
      @special_skills = thisUser.special_skills rescue nil
      if params["commit"] == "Continue"
        if thisUser and thisUser.validate_and_update(params)
          if !thisUser.member_active
            thisUser.member_active = true
	    thisUser.save
	    redirect_to("/member/member_payment")
          else
            flash.now[:error] = "You already signed up!"
          end
        else
          flash.now[:error] = "Please enter the correct format/fill in all fields are required."
        end
      end
    else
      flash[:error] = "You need to sign up or login first!"
      redirect_to("/member")
    end
  end

  def account_setup_non_member
    thisUser = Member.find_by_email(session[:user_email])
    if thisUser
      @first = thisUser.first rescue nil
      @last = thisUser.last rescue nil
      @address1 = thisUser.address1 rescue nil
      @address2 = thisUser.address2 rescue nil
      @city = thisUser.city rescue nil
      @state = thisUser.state rescue nil
      @zip = thisUser.zip rescue nil
      @telephone = thisUser.telephone rescue nil
      if params["commit"] == "Submit"
        if thisUser and thisUser.validate_and_update_non_member(params)
          if !thisUser.non_member_active
            thisUser.non_member_active = true
            thisUser.save
            redirect_to("/member/thanks_after_done")
          else
            flash.now[:error] = "You already signed up as a non-member!"
          end
        else
          flash.now[:error] = "Please enter the correct format/fill in the required fields."
        end
      end
    else
      flash[:error] = "You need to sign up or login first!"
      redirect_to("/member")
    end
  end
  
  def edit_member_profile
    thisUser = Member.find_by_email(session[:user_email])
    if thisUser
      @first = thisUser.first rescue nil
      @last = thisUser.last rescue nil
      @address1 = thisUser.address1 rescue nil
      @address2 = thisUser.address2 rescue nil
      @city = thisUser.city rescue nil
      @state = thisUser.state rescue nil
      @zip = thisUser.zip rescue nil
      @telephone = thisUser.telephone rescue nil
      @year_of_birth = thisUser.year_of_birth rescue nil
      @country_of_birth = thisUser.country_of_birth rescue nil
      @special_skills = thisUser.special_skills rescue nil
      if params["commit"] == "Continue"  
        if thisUser and thisUser.validate_and_update(params)
           if verify_recaptcha 
             @first = thisUser.first rescue nil
             @last = thisUser.last rescue nil
             @address1 = thisUser.address1 rescue nil
             @address2 = thisUser.address2 rescue nil
             @city = thisUser.city rescue nil
             @state = thisUser.state rescue nil
             @zip = thisUser.zip rescue nil
             @telephone = thisUser.telephone rescue nil
             @year_of_birth = thisUser.year_of_birth rescue nil
             @country_of_birth = thisUser.country_of_birth rescue nil
             @special_skills = thisUser.special_skills rescue nil
             redirect_to("/member/edit_success")
          else
             flash[:error] = "Your words do not match the ones in the recaptcha image!"
          end
        else
          flash.now[:error] = "Please enter the correct format/fill in all fields are required."
        end
      end
   else
     flash[:error] = "You need to sign up or login first!"
     redirect_to("/member")
   end
 end

  def edit_non_member_profile
    thisUser = Member.find_by_email(session[:user_email])
    if thisUser
      @first = thisUser.first rescue nil
      @last = thisUser.last rescue nil
      @address1 = thisUser.address1 rescue nil
      @address2 = thisUser.address2 rescue nil
      @city = thisUser.city rescue nil
      @state = thisUser.state rescue nil
      @zip = thisUser.zip rescue nil
      @telephone = thisUser.telephone rescue nil
      if params["commit"] == "Submit"
        if thisUser and thisUser.validate_and_update_non_member(params)  
           if verify_recaptcha
             @first = thisUser.first rescue nil
             @last = thisUser.last rescue nil
	     @address1 = thisUser.address1 rescue nil
	     @address2 = thisUser.address2 rescue nil
	     @city = thisUser.city rescue nil
	     @state = thisUser.state rescue nil
	     @zip = thisUser.zip rescue nil
	     @telephone = thisUser.telephone rescue nil
             redirect_to("/member/edit_success")
           else
             flash[:error] = "Your words do not match the ones in the recaptcha image!"
           end
        else
           flash.now[:error] = "Please enter the correct format/fill in the required fields."
        end
     end
    else
      flash[:error] = "You need to sign up or login first!"
      redirect_to("/member")
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

  
  def destroy
    redirect_to("/member")
    session.delete(:user_email)#clear user data from session
  end

  def profile
    thisUser = find_user_by_email(session[:user_email])
    if thisUser
      @admin = true if thisUser.admin
      @user_data = thisUser.user_data
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
       
       if params["commit"] == "Delete"
         if params["delete_member"]
           this_user.delete_id = params["delete_member"]
           this_user.save
           redirect_to("member/admin")
         end
         Member.delete(Member.find(this_user.delete_id))
       end

       if params["commit"] == "Edit"
         if params["edit_member"]
           this_user.delete_id = params["edit_member"]
           this_user.save
           redirect_to("/member/edit_member_profile")
         end
       end
   
    else 
	redirect_to("/member")
        flash[:error] = "You are not logged in- please log in first."
    end
  end

  def admin_edit_member_profile
    this_user = find_user_by_email(session[:user_email])
    if this_user.admin != true
      redirect_to("/member")
      flash[:error] = "Sorry, you are not an admin, login as an admin first!"
    else #member is admin
      member_to_edit = Member.find(this_user.delete_id) #now we have the user to edit
      @first = member_to_edit.first rescue nil
      @last = member_to_edit.last rescue nil
      @address1 = member_to_edit.address1 rescue nil
      @address2 = member_to_edit.address2 rescue nil
      @city = member_to_edit.city rescue nil
      @state = member_to_edit.state rescue nil
      @zip = member_to_edit.zip rescue nil
      @telephone = tmember_to_edit.telephone rescue nil
      @year_of_birth = member_to_edit.year_of_birth rescue nil
      @country_of_birth = member_to_edit.country_of_birth rescue nil
      @special_skills = member_to_edit.special_skills rescue nil
      if params["commit"] == "Continue"
        if params["first-name"] and params["first-name"] =~ /[A-Za-z]+/; member_to_edit.first = params["first-name"]; end;
      	if params["last-name"] and params["last-name"] =~ /[A-Za-z]+/; member_to_edit.last = params["last-name"]; end;
        if params["address-line-1"] and params["address-line-1"] =~ /\d|[-]|[A-Za-z]+|\s|./; member_to_edit.address1 = params["address-line-1"]; end;
        if params["address-line-2"] and params["address-line-2"] =~ /\d|[-]|[A-Za-z]+|\s|./; member_to_edit.address2 = params["address-line-2"]; end;
        if params["already_a_member"]; member_to_edit.already_a_member = params["already_a_member"]; end;
        if params["number_of_children"]; member_to_edit.number_of_children = params["number_of_children"]; end;
        if params["city"] and params["city"] =~ /[A-Za-z]+/; member_to_edit.city = params["city"]; end;
        if params["zip"] and params["zip"] =~ /\d{5}/; member_to_edit.zip = params["zip"]; end;
        if params["state"] and params["state"] =~ /[A-Za-z]{2}/; member_to_edit.state = params["state"]; end;
        if params["telephone"] and params["telephone"] =~ /\d{1,10}|[-]/; member_to_edit.telephone = params["telephone"]; end;
        if params["year_of_birth"] and params["year_of_birth"] =~ /\d{1,4}/; member_to_edit.year_of_birth = params["year_of_birth"]; end;
        if params["country_of_birth"] and params["country_of_birth"] =~ /[A-Za-z]+/; member_to_edit.country_of_birth = params["country_of_birth"]; end;
        if params["occupation"]; member_to_edit.occupation = params["occupation"]; end;
        if params["gender"]; member_to_edit.gender = params["gender"]; end;
        if params["special_skills"] and params["special_skills"] =~ /[A-Za-z]+/; member_to_edit.special_skills = params["special_skills"]; end;
        member_to_edit.save
        redirect_to("/member/admin")
      end
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
      render "csv_export.csv.erb", :content_type => content_type
    end
  end
end
