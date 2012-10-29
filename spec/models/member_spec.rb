require "spec_helper"

describe Member do
   it "When user signs up, a new user should be created" do
       mock = mock('Member')
       mock.stub!(:signup).and_return('true')
       mock.stub!(:confirm).with(:code => '1234', :password =>'1234').and_return('true')
   end
   it "should confirm codes" do 
       member1 = Factory(:member)
       mock = mock('Member')
       member1.confirm('1234').should_not == mock
   end
end
