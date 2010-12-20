Feature: Send Emails to Users

	As an Inventory Manager
	I want to be able to send an email to users
	To ask them f.ex. whether they could bring back stuff earlier


Background:
        Given a minimal leihs setup
	Given comment: the admin
	Given comment: And the mail queue is empty
	Given comment: And we setup Culerity Logging as we like


@javascript
Scenario: Admin: create user and directly mail him

	When I log in as the admin
	When I press "Backend"
	 And I create a new user 'Joe' at 'joe@example.com'
	When I follow "Write Email"
	Then I should be on the new backend mail page
	When I fill in "subject" with "Welcome to leihs"
	 And I fill in "body" with "Now you can borrow stuff"
	 And I press "Send"
	Then joe@example.com receives an email
	Then I follow "Logout"

@javascript
Scenario: Admin: create user in an inventory pool and mail him from there

       Given inventory pool 'Central Park'
         And the admin
         And he is a manager
         And he has access level 3
	When I log in as the admin
	When I press "Backend"
	When I follow "Central Park"
	 And I create a new user 'Joe' at 'joe@example.com'
	When I follow "Write Email"
	 And I fill in "subject" with "Welcome to leihs"
	 And I fill in "body" with "Now you can borrow stuff"
	 And I press "Send"
	Then joe@example.com receives an email
	Then I follow "Logout"


