class MemberController < ApplicationController
  def signup
    if params[:email]
      if Member.create(:email => params[:email], :status => "Pending", :member_type => "Mailing list", :password => "1234")
        redirect_to("/member/thanks")
      else 
        flash[:error] = "Your account could not be created"
      end
    end
  end
  
  def confirm_account
    if params[:email] and params[:code]
      thisUser = Member.find_by_email(params[:email])
      if thisUser and thisUser.confirm(params[:code])
        redirect_to("/member/account_setup")
      else
        flash[:error] = "Please click the confirmation link emailed to you"
      end
    end
  end
end
