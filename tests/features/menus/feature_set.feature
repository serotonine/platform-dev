@api
Feature: Feature set menu
  In order to easily enable a feature
  As an administrative user
  I want to have a list of features to be enabled

  @api
  Scenario: Test feature set screen as administrator
    Given I am logged in as a user with the "administrator" role
    When I am on "admin/structure/feature-set_en"
    Then I should see the text "Content slider"
    And I should see the text "Events"
    # Cannot use "Links" label to test if administrator user can see the "Links"
    # feature because it is already elsewhere on the page for another purpose.
    And I should see the text "Allows contributors to store a bookmark/URL to another website they wish to share with visitors."
    And I should see the text "Multi-user blog"
    And I should see the text "Meta tags"
    And I should see the text "Registration"
    And I should see the text "Text collapse"
    And I should see the text "Webtools"
    And I should see the text "Wiki"
    And I should see the text "WYSIWYG Tracked Changes"
    And I should see the text "World Countries"
    And I should see the text "F.A.Q"
    And I should see the text "Press Release"
    And I should see the text "Site activity"
    And I should see the text "Maxlength"
    And I should see the text "News"
    And I should see the text "Newsletters"
    And I should see the text "GIS field"
    And I should see the text "GeoJson feeds"
    # Cannot use "Integration" label to test if administrator user can see the
    # "Integration" feature because it is already elsewhere on the page for
    # another purpose.
    And I should see the text "Provides common NextEuropa backend settings and schemas used by the Integration module."
    And I should see the text "Rule-based web frontend cache purging"
    And I should see the text "E-library"
    And I should see the text "Embedded images "
    And I should see the text "Embedded videos"
    And I should see the text "Audio"
    And I should see the text "Media Gallery"
    And I should see the text "Multilingual tools"
    And I should see the text "Translation requests"
    And I should see the text "Splash screen"
    And I should see the text "Fat footer"
    And I should see the text "Mega menu"
    And I should see the text "Node pager"
    And I should see the text "Sitemap"
    And I should see the text "Business indicators"
    And I should see the text "Contact form"
    And I should see the text "Ideas"
    And I should see the text "Surveys"
    And I should see the text "Extend Profiles"
    And I should see the text "Notifications"
    And I should not see the text "Nexteuropa DGT Connector"

  @api
  Scenario: Test feature set screen as cem
    Given I am logged in as a user with the "cem" role
    When I am on "admin/structure/feature-set_en"
    Then I should not see the text "Content slider"
    Then I should not see the text "Events"
    # Cannot use "Links" label to test if cem user cannot see the "Links"
    # feature because it is already elsewhere on the page for another purpose.
    Then I should not see the text "Allows contributors to store a bookmark/URL to another website they wish to share with visitors."
    Then I should not see the text "Multi-user blog"
    Then I should not see the text "Meta tags"
    Then I should not see the text "Registration"
    Then I should not see the text "Webtools"
    Then I should not see the text "Wiki"
    Then I should not see the text "WYSIWYG Tracked Changes"
    Then I should not see the text "World Countries"
    Then I should not see the text "WYSIWYG Tracked Changes"
    Then I should not see the text "F.A.Q"
    Then I should not see the text "Press Release"
    Then I should not see the text "Site activity"
    Then I should not see the text "Maxlength"
    Then I should not see the text "News"
    Then I should not see the text "Newsletters"
    Then I should not see the text "GIS field"
    Then I should not see the text "GeoJson feeds"

    # Cannot use "Integration" label to test if cem user cannot see the
    # "Integration" feature because it is already elsewhere on the page for
    # another purpose.
    Then I should not see the text "Provides common NextEuropa backend settings and schemas used by the Integration module."
    Then I should not see the text "Rule-based web frontend cache purging"
    Then I should not see the text "E-library"
    Then I should not see the text "Embedded images"
    Then I should not see the text "Embedded videos"
    Then I should not see the text "Audio"
    Then I should not see the text "Media Gallery"
    Then I should not see the text "Multilingual tools"
    Then I should not see the text "Translation requests"
    Then I should not see the text "Splash screen"
    Then I should not see the text "Fat footer"
    Then I should not see the text "Mega menu"
    Then I should not see the text "Node pager"
    Then I should not see the text "Business indicators"
    Then I should not see the text "Sitemap"
    Then I should not see the text "Contact form"
    Then I should not see the text "Ideas"
    Then I should not see the text "Surveys"
    Then I should not see the text "Extend Profiles"
    Then I should not see the text "Notifications"
    And I should see the text "Nexteuropa DGT Connector"
