Feature: Going to the Paypal Page
   As an unpaid member of the organization
   I want to be able to pay $25 for membership fees

Scenario: Get directed to PayPal website
   Given I am a member
   When I press "PayPal"
   Then I should be on the PayPal page


