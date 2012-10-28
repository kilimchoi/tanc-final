Given /^the following members exist:$/ do |table|
  # table is a Cucumber::Ast::Table
  table.hashes.each do |member|
    Member.create!(member)
  end
end
