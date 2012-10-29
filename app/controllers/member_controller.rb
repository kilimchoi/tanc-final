class MemberController < ApplicationController
  def signup
    if (params[:email] && params[:email] =~ /^\S+@\S+\.\S+$/)
      if Member.create(:email => params[:email], :status => "Pending", :member_type => "Mailing list", :password => "1234")
        redirect_to("/member/confirm_account")
      else 
        flash[:error] = "Your account could not be created"
        redirect_to("/member/signup")
      end
    else
	flash[:error] = "Couldn't validate your email"
        redirect_to("/member")
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
        redirect_to("/member")
      end
    end
  end
end

