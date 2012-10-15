Feature: Update Website
  	As an admin
  	In order to keep the website updated
  	I want to edit the website contents


  Background: Update Website Contents
  	Given Website Admin Panel is set up
  	And I am logged into the admin panel


  Scenario: Create a new page
  	When I follow newPage button
  	Then I should be on new page
  	And I fill the title with “foobar”
  	And I fill the body with “Lorem Ipsum”
  	And I click the publish button
  	Then I should be on the Website Admin Panel Home Page


  Scenario: Edit an existing page
  	When I follow pages 
  	Then I should be on pages list
  	When I follow “foobar” page
  	And I follow edit button
  	Then I can edit “foobar” page
  	And I click the publish button
