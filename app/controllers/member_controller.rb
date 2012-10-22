class MemberController < ApplicationController
  def signup
    if params[:email]
      if true #Member.create!(params[:email])
        redirect_to("/member/confirm_account")
      else 
        flash[:error] = "Your account could not be created"
      end
    end
  end
  
  def confirm_account
    if params[:code]
      if true #Member.confirm(code)
        redirect_to("/member/thanks")
      else
        flash[:error] = "Please click the confirmation link emailed to you"
      end
    end
  end

end
