Given /^the following members exist:$/ do |table|
  # table is a Cucumber::Ast::Table
  table.hashes.each do |member|
    Member.create!(member)
  end
end
Given /^I confirm email with "(.*?)" and confirm password with "(.*?)"$/ do |arg1, arg2|
  arg1 == "hjvds@berkeley.edu" and arg2 == "1234"
end
