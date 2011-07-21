Feature: Sign in
  In order to prevent unauthorised access to the system
  users
  must be required to sign in
  
  Scenario: Arriving at a random page on the site
    Given I have one user "tom.counsell@decc.gsi.gov.uk" with password "testpassword"
    And   a home page
    And   a page with title "earlier in the alphabet" and content "not really relevant"
    When  I go to the homepage
    Then  I should see "Sign in"
    And   I fill in "tom.counsell@decc.gsi.gov.uk" for "user_email"
    And   I fill in "testpassword" for "user_password"
    And   I press "Sign in"
    Then  I should see "this is the home page"
    
  