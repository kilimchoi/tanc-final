Feature: Paying membership fee
   As a member of the organization
   I want to be able to pay $25 for membership fees

Scenario: Paying membership fee online
   Given I am a member
   And I am on the tanc/member/member_payment page
   When I press "pay online"
   Then I should be on the PayPal page

Scenario: Paying membership fee by check or cash
   Given I am a member
   And I am on the tanc/member/member_payment page
   When I press "pay by check or cash"
   Then I should be on the tanc/member/thank_you page

Scenario: Not paying membership fee
   Given I am a member
   And I am on the tanc/member/member_payment page
   When I press "No Thanks"
   Then I should be on the tanc/member/thank_you page
