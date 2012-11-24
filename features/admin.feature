Feature: Managing website
	As an admin
	In order to keep the website updated
	I want to edit the website entries  

Background: 
        Given I am logged in as an admin 
	Then I should be on the admin page
	
Scenario: Create a new page
	When I press "new_page" 
	Then I should be on the admin_new page
	Then I fill in "title" with "about us" 
	And I fill in "content" with "lorem ipsum" 
	And I press "publish" 
	Then I should be on the admin page

Scenario: Edit an existing page
	When I follow "page_name" 
	Then I should be on the admin_edit page
	Then I fill in "content" with "blah"
	And I press "publish" 
	Then I should be on the admin page

Scenario: Delete a page
	When I press "delete" 
	Then I should be on the delete_confirm page
	And I press "save"
        Then I should be the admin page
