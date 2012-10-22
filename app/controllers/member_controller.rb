class MemberController < ApplicationController
  def signup
    if params[:email]
      if Member.create(:email => params[:email], :status => "Pending", :type => "Mailing list")
        redirect_to("/member/confirm_account")
      else 
        flash[:error] = "Your account could not be created"
      end
    end
  end
  
  def confirm_account
    if params[:email] and params[:code]
      thisUser = Member.find_by_email(params[:email])
      if thisUser and thisUser.confirm(code)
        redirect_to("/member/thanks")
      else
        flash[:error] = "Please click the confirmation link emailed to you"
      end
    end
  end
end
