# TL;DR: YOU SHOULD DELETE THIS FILE
#
# This file is used by web_steps.rb, which you should also delete
#
# You have been warned
module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /^the home\s?page$/
      '/'
    when /^the login\s?page$/ then '/member/login'
    when /^the sign up\s?page$/ then '/member/signup'
    when /^the thanks\s?page$/ then '/member/thanks'
    when /^the account setup\s?page$/ then '/member/account_setup'
    when /^the next account setup\s?page$/ then '/member/account_setup_member'
    when /^the next account setup non-member\s?page$/ then '/member/account_setup_non_member'
    when /^profile\s?page$/ then '/member/profile'
    when /^the confirm account page$/ then '/member/confirm_account'
    when /^the database\s?page$/ then '/admin/db_manage'
    when /^the add\s?page$/ then '/admin/add_member'
    when /^the confirmation\s?page$/ then '/admin/member_confirmation'
    when /^the edit\s?page$/ then '/admin/edit_member'
    when /^the delete confirmation\s?page$/ then '/admin/delete_confirmation'
    when /^the mass email\s?page$/ then '/admin/mass_email'
    when /^the PayPal\s?page$/ then ''
    when /^the member payment\s?page$/ then '/member/member_payment' 
    when /^the Thank You\s?page$/ then '/member/thanks_after_done'
    when /^the Check Cash\s?page$/ then '/member/check_cash_payment'
    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
