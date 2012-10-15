Feature: new user sign up

Background:
	Given I am on the member login page
	And I fill in the email field
	And I check ‘No, sign me up!’ box
	And I Follow sign in
	#Then I should be on the confirm email page
	#Then an email should be sent
	# Once I click the link in my email
	Then I should be on the membership setting page
     
Scenario: sign up as a new full member
	Given I am on the membership settings page
	And I check the ‘Full Member’ box
	Then I should be on the Membership Settings page	
	And I fill in the ‘email’ field
	And I fill in the ‘password’ field
	And I fill in the ‘confirm’ field
	And I fill in the ‘address’ field
	And I fill in the ‘city’ field
	And I fill in the ‘zipcode’ field
	And I fill in the ’phone’ field
	And I follow ‘Save’
	Then I should be on the Payment Info page
	When I click ‘Check’
	Then I should be on the Thank You page


  Scenario: sign up only for mailing list
	Given I am on the membership settings page
	And I fill in the ‘email’ field
	And I fill in the ‘password’ field
	And I fill in the ‘confirm’ field
	And I check the ‘mailing list’ box
	And I follow ‘Save’
	Then I should be on the Thank You page
