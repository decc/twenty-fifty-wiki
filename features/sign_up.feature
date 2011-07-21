Feature: Sign up
  In order to use the system
  users
  want to be able to sign up
  
  Scenario: Arriving at the site for the first time
    When  I go to the homepage
    Then  I should see "Sign in"
    And   I should see "Sign up"
    When  I follow "Sign up"
    Then  I should see "You can sign up for an account using your decc email address"
    Given I fill in "tom.counsell@decc.gsi.gov.uk" for "user_email"
    And   I fill in "test-of-a-password" for "user_password"
    And   I fill in "test-of-a-password" for "user_password_confirmation"
    And   I press "Sign up"
    Then  I should see "A confirmation was sent to your e-mail"
    Then  "tom.counsell@decc.gsi.gov.uk" should receive an email with subject "Confirmation instructions"
    
  Scenario: The wrong sort of person
    When  I go to the homepage
    Then  I should see "Sign in"
    And   I should see "Sign up"
    When  I follow "Sign up"
    Then  I should see "You can sign up for an account using your decc email address"
    Given I fill in "tom.counsell@not-decc.gsi.gov.uk" for "user_email"
    And   I fill in "test-of-a-password" for "user_password"
    And   I fill in "test-of-a-password" for "user_password_confirmation"
    And   I press "Sign up"
    Then  I should see "Email is invalid"
    Then  "tom.counsell@decc.gsi.gov.uk" should receive no emails with subject "Confirmation instructions"    

  Scenario: A person who doesn't like secure passwords
    When  I go to the homepage
    Then  I should see "Sign in"
    And   I should see "Sign up"
    When  I follow "Sign up"
    Then  I should see "You can sign up for an account using your decc email address"
    Given I fill in "tom.counsell@decc.gsi.gov.uk" for "user_email"
    And   I fill in "t" for "user_password"
    And   I fill in "t" for "user_password_confirmation"
    And   I press "Sign up"
    Then  I should see "Password is too short (minimum is 6 characters)"
    Then  "tom.counsell@decc.gsi.gov.uk" should receive no emails with subject "Confirmation instructions"
