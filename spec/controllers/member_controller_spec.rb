require "spec_helper"

describe MemberController do
   it "When user submits the code, it should be confirmed" do 
	mock = mock('Member')
        Member.stub!(:confirm).and_return('true')
        get :confirm_account, {:email => 'bwdwd@berkeley.edu', :code => '1234'}
   end
  
    it "should sign up members" do
        mock = mock('Member')
        Member.stub!(:signup).and_return('true')
     	get :signup, {:email => "oski@berkeley.edu", :status => 	"Pending", :member_type => "Mailing list", :password => "1234"} 
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

