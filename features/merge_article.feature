Feature: Merge Articles
  As a blog administrator
  In order to simplify list of articles
  I want to be able to merge articles of my blog

  Background:
    Given the blog is set up
    
    And the following users exist:
    | login | password | email          | profile_id | name  | state   |
    | user1 | abcdefg  | john@host.com  | 2          | John  | active  |
    | user2 | abcdefg  | jane@host.com  | 3          | Jane  | active  |
  
    And the following articles exists
     | id | title | author | body        | allow_comments | published_at        |
     | 3  | Foo   | user1  | Lorem Ipsum | true           | 2013-01-01 00:00:01 |
     | 4  | Bar   | user2  | Nice guy    | true           | 2013-01-01 00:00:01 |
     
    And the following comments exist:
     | id | type    | author | body      | article_id | user_id | created_at          |title|excerpt|updated_at          | text_filter_id|whiteboard|email|url|
     | 1  | Comment | user1  | Comment 1 | 3          | 2       | 2013-02-22 11:11:11 |     |       |2013-02-22 11:11:11 |  | | | |
     | 2  | Comment | user2  | Comment 2 | 4          | 3       | 2013-02-22 12:12:12 |     |       |2013-02-22 12:12:12 | | | | |
     

  Scenario: Non-admin cannot merge articles
    Given I am logged in as "user1" with password "abcdefg"
    When I follow "Articles"
    And I follow "Foo"
    Then I should not see "merge_with"

  Scenario: Successfully merge articles
    Given I am logged into the admin panel
    When I follow "Articles"
    And I follow "Foo"
    And I fill in "merge_with" with "4"
    And I press "Merge"
    Then I should see "Articles merged successfully" 
    
  Scenario: Merged article should contain text of both
    Given I am logged into the admin panel
    And articles 3 and 4 were merged
    When I follow "All Articles"
    And I follow "Foo"
    Then I should see "Lorem Ipsum"
    And I should see "Nice guy"
 
  Scenario: Merged article should have one author (from either of original)
    Given I am logged into the admin panel
    And articles 3 and 4 were merged
    When I follow "Articles"
    Then I should see "user1"
    And I should not see "user2"
 
  Scenario: Merged article should have the comments from both the originals
    Given I am logged into the admin panel
    And articles 3 and 4 were merged
    When I follow "Articles"
    And I follow "Foo"
    Then I should see "Comment 1"
    And I should see "Comment 2"
 
  Scenario: Merged article should have one title (from either of original)
    Given I am logged into the admin panel
    And articles 3 and 4 were merged
    When I follow "Articles"
    Then I should see "Foo"
    And I should not see "Bar"