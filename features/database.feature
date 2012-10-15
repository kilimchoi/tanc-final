Feature: Managing Database
	As an admin
	In order to keep the database updated
	I want to edit the database entries  


Background: Update Database Entries
	Given Database Admin Panel is set up
	I want to edit the Database Entries


Scenario: View member status
	Given I am logged into the database admin panel
	I should see members profiles
  
Scenario: Adding a member
	Given I am on the members profile page
	And I click on new
	I should be on new member page
	And I click on submit
	I should be on the members profile page
	And i should see “member”


Scenario: Editing a member
	Given I am on the members profile page
	And I click on edit
	I should be on edit member page
	And I click on submit
	I should be on the members profile page


Scenario: Deleting a member
	Given I am on the members profile page
	And i click on edit
	I should be on edit member page
	And I click on delete
	I should be on member profile page
	And I should not see “member” 
