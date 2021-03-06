@api
Feature: Check Piwik
  In order to check if the type attribute is set for the Piwik element.
  As an administrator
  I want to check Piwik is available.
  # Advanced PIWIK rules functionality
  In order to make PIWIK analysis more granular and accurate
  As a site administrator
  I can define advanced PIWIK rules to define the site section based on path or regular expression

  Background:
    Given these modules are enabled
      | modules            |
      | nexteuropa_piwik   |
    And I am logged in as a user with the "PIWIK administrator" role

  Scenario: Check if the PIWIK script is embedded into the page correctly
    Given I am on the homepage
    Then the response should contain "{\"utility\":\"piwik\",\"siteID\":\"\",\"sitePath\":[\"\"],\"is404\":false,\"is403\":false,\"instance\":\"\"}"
    # The meta tag below must be present in order that the PIWIK script works correctly (see NEPT-1042).
    And the response should contain the meta tag with the "X-UA-Compatible" name and the "IE=edge" content

  Scenario: Check if the PIWIK script flags non existing pages
    Given I go to "falsepage"
    Then the response should contain "{\"utility\":\"piwik\",\"siteID\":\"\",\"sitePath\":[\"\"],\"is404\":true,\"is403\":false,\"instance\":\"\"}"
    # The meta tag below must be present in order that the PIWIK script works correctly (see NEPT-1042).
    And the response should contain the meta tag with the "X-UA-Compatible" name and the "IE=edge" content

  Scenario: Check if the PIWIK script flags forbidden pages
    Given these modules are enabled
      | modules            |
      | ecas_env           |
    And I go to "ecaslogout"
    Then the response should contain "{\"utility\":\"piwik\",\"siteID\":\"\",\"sitePath\":[\"\"],\"is404\":false,\"is403\":true,\"instance\":\"\"}"
    # The meta tag below must be present in order that the PIWIK script works correctly (see NEPT-1042).
    And the response should contain the meta tag with the "X-UA-Compatible" name and the "IE=edge" content

  @delete_piwik_rules @ec_resp_theme
  Scenario: View advanced PIWIK rules.
    Given the nexteuropa_piwik module is configured to use advanced PIWIK rules
    And the following PIWIK rules:
      | Rule language | Rule path       | Rule path type | Rule section         |
      | all           | ^admin/*        | regexp         | Regexp based section |
      | en            | content/test    | direct         | Direct path section  |
    When I go to "/admin/config/system/webtools/piwik/advanced_rules"
    Then I see an overview with the following PIWIK rules:
      | Rule language | Rule path       | Rule path type | Rule section         |
      | all           | ^admin/*        | regexp         | Regexp based section |
      | en            | content/test    | direct         | Direct path section  |

  @javascript @delete_piwik_rules @ec_resp_theme
  Scenario: Add a PIWIK rule.
    Given the nexteuropa_piwik module is configured to use advanced PIWIK rules
    When I go to "/admin/config/system/webtools/piwik/advanced_rules"
    And I click "Add piwik rule"
    And I fill in "Site section" with "Regexp based section"
    And I select "English" from "Language"
    And I select the radio button "Path based on regular expression" with the id "edit-rule-type-regexp"
    And I wait for AJAX to finish
    And I fill in "Site path" with "^admin/*"
    And I press the "Save" button
    Then I see an overview with the following PIWIK rules:
      | Rule language | Rule path       | Rule path type | Rule section         |
      | en            | ^admin/*        | regexp         | Regexp based section |

  @delete_piwik_rules @ec_resp_theme
  Scenario: Remove a PIWIK rule.
    Given the nexteuropa_piwik module is configured to use advanced PIWIK rules
    And "page" content:
      | title     | field_ne_body         |
      | Test page | The test body content |
    And the following PIWIK rules:
      | Rule language | Rule path       | Rule path type | Rule section         |
      | all           | ^admin/*        | regexp         | Regexp based section |
      | en            | content/test    | direct         | Direct path section  |
    When I go to "/admin/config/system/webtools/piwik/advanced_rules"
    And I click "delete" next to the 2nd PIWIK rule
    And I press the "Confirm" button
    Then I see an overview with the following PIWIK rules:
      | Rule language | Rule path       | Rule path type | Rule section         |
      | all           | ^admin/*        | regexp         | Regexp based section |
    And I should not see the text "content/test"
    When I go to "content/test"
    Then the response should not contain "\"siteSection\":\"Direct path section\""

  @delete_piwik_rules
  Scenario: Assert that the direct path PIWIK rule is triggered and embedded correctly.
    Given the nexteuropa_piwik module is configured to use advanced PIWIK rules
    And the following PIWIK rules:
      | Rule language | Rule path       | Rule path type | Rule section         |
      | en            | content/test    | direct         | Direct path section  |
    And "page" content:
      | title | field_ne_body | status |
      | Test  | Test          | 1      |
    And I go to "content/test_en"
    Then the response should contain "\"siteSection\":\"Direct path section\""

  @delete_piwik_rules
  Scenario: Assert that the regular expression based PIWIK rule is triggered and embedded correctly.
    Given the nexteuropa_piwik module is configured to use advanced PIWIK rules
    And the following PIWIK rules:
      | Rule language | Rule path                                     | Rule path type | Rule section         |
      | all           | ^content/.*                                    | regexp         | Regexp based section |
      | all           | ^content/priorities.*                          | regexp         | priorities           |
      | all           | ^content/prioritiesstate-union-speeches.*      | regexp         | prioritiessou        |
      | all           | ^content/prioritiesstate-union-speeches-2018.* | regexp         | prioritiessou2018    |
    And "page" content:
      | title                                    | field_ne_body          | status |
      | Testing Title no 1                       | Body content no 1      | 1      |
      | Priorities                               | Body content no 2      | 1      |
      | Prioritiesstate union speeches           | Body content no 3      | 1      | 
      | Prioritiesstate union speeches 2018      | Body content no 4      | 1      |
      | Prioritiesstate union speeches 2018 test | Body content no 5      | 1      |
    When I go to "content/testing-title-no-1_en"
    Then the response should contain "\"siteSection\":\"Regexp based section\""
    When I go to "content/priorities_en"
    Then the response should contain "\"siteSection\":\"priorities\""
    When I go to "content/prioritiesstate-union-speeches_en"
    Then the response should contain "\"siteSection\":\"prioritiessou\""
    When I go to "content/prioritiesstate-union-speeches-2018_en"
    Then the response should contain "\"siteSection\":\"prioritiessou2018\""
    When I go to "content/prioritiesstate-union-speeches-2018-test_en"
    Then the response should contain "\"siteSection\":\"prioritiessou2018\""
