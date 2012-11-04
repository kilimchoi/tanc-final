Given /^the following members exist:$/ do |table|
  # table is a Cucumber::Ast::Table
  table.hashes.each do |member|
    Member.create!(member)
  end
end

Given /^I logged in as "(.*?)" with password "(.*?)"$/ do |arg1, arg2|
  visit '/member/confirm_account?email=%s&code=%s' % [arg1, arg2]
end
