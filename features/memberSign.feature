Feature: Sign up for mailing list as a non member
	As a non-member, 
	I want to sign up my email 
	so that I can receive updates 

Scenario: Sign up as a nonmember
	Given I am on the tanc/login_signup
	When I fill in email with "my_email@berkeley.edu"
        Then I should see "Do you have existing account?"
        And I check "No, sign me up!"
	When I press "sign_in"
        Then I should be on the tanc/account_created

Background:
        Given I am on the tanc/new_account
        When I fill in email with "my_email@berkeley.edu"
	When I fill in password with "secret_password"
        When I fill in confirm_password with "secret_password"

Scenario: Setting non-member profile
	And I check non_member 
	And I press "save"
	Then I should be on the tanc/non_member_thank_you

Background: 
	And I check member
        And I press "save" 
        Then I should be on the tanc/member_set_up
        Given I fill in all_member_info
        And I press "save"
        Then I should be on tanc/payment_setup

Scenario: Setting member profile without online payment
        When I press "check-cash"
        Then I should be on tanc/member_thank_you 
    
Scenario: Setting member profile with online payment
	When I press "credit_card"
	Then I should be on tanc/online_payment_setup


