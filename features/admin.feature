
Feature: Managing website
	As an admin
	In order to keep the website updated
	I want to edit the website entries  

Background: 
        Given I am logged in as an admin 
	Then I should be on tanc/admin
	
Scenario: Create a new page
	When I press "new_page" 
	Then I should be on tanc/admin/new_page
	Then I fill in "title" with "about us" 
	And I fill in "content" with "lorem ipsum" 
	And I press "publish" 
	Then I should be on tanc/admin/

Scenario: Edit an existing page
	When I follow "page_name" 
	Then I should be on tanc/admin/1/edit
	Then I fill in "content" with "blah"
	And I press "publish" 
	Then I should be on tanc/admin/

Scenario: Delete a page
	When I press "delete" 
	Then I should be on tanc/admin/delete_confirm
	And I press "save"
        Then I should be tanc/admin/
