Feature: Administrator rights
  Scenario: Login as Administrator
	When I log in as an administrator
	I should be on the administrator page
	And I should see the ‘add new member’ button


  Scenario: Add a new member
	Given I am on the Administrator page
	And I am logged in as an Administrator
	When I click the ‘add new member’ button
	And I fill in names 
	And I check member or nonmember
	And I click the publish button 
	Then I should see success page


  Scenario: Delete an existing member
	Given I am on the Administrator page
	And I am logged in as an Administrator
	And I choose a member
	And I click the ‘delete a member’ button
	Then I should see success page
