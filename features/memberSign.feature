Feature: Sign up for mailing list as a non member
	As a non-member, 
	I want to sign up my email 
	so that I can receive updates 

Scenario: Sign up as a nonmember
	Given I am on the website page 
	And I check the ‘No, sign me up!’ box
	Then I click signup button 
	And I should be on signup form page 
	Then I fill up email 
	Then I click signup 
	Then an email should be sent
	# Once I click link in my email	
	Then I should see the ‘Thank You’ page
