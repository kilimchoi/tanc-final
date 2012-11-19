require "spec_helper"

describe MemberController do
    it "should sign up user" do 
       get :signup, {:email => "oski@berkeley.edu"}
       @member = mock('Member')
       Member.stub!(:find_by_email).with("oski@berkeley.edu").and_return(@member)          end
    it "should confirm account" do
        get :confirm_account, {:email => "oski@berkeley.edu"}
    end
    it "Should set up the account for members" do
        mock = mock('Member')
        mock.stub!(:commit).and_return("Continue")
        mock.stub!(:user_email).and_return("oski@berkeley.edu") 
     end
     it "should login" do
	get :profile, {:email => "oski@berkeley.edu", :password => "1234"}
     end
     it "should go to the login" do
        get :login, {:email => "oski@berkeley.edu", :password => "1234"}
        controller.stub!(:find_user_by_email).with("oski@berkeley.edu")
        response.should be_successful 
     end
     it "should not login when wrong action" do
 	mock = mock('Member')
	mock.stub!(:commit).and_return("Continue")
	mock.stub!(:find_by_email).with("myemail@gmail.com").should_not == mock
        mock.stub!(:user_exists_valid).with('false')
        
    end
end

describe "test the controller" do 
   before(:each) do
      @member = mock('member')
   end
   describe "for those with proper email and code" do
      it "should find members by emails" do 
         Member.stub!(:find_by_email).with("oski@berkeley.edu").and_return(@member)
      end
   end
end
