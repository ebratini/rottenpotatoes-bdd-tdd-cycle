Then /^(?:|I )should either be on (.+) or (.+)$/ do |page1, page2|
  steps %Q{
    Then I should be on #{ page1 }
    And I should be on #{ page2 }
  }
end
