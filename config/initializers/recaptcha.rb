# Rails plugin initialization.
# You can also install it as a gem:
#   config.gem "ambethia-recaptcha", :lib => "recaptcha/rails", :source => "http://gems.github.com"

require File.dirname(__FILE__) + '/recaptcha' 
ENV['RECAPTCHA_PUBLIC_KEY'] = '6Le4nNkSAAAAAO1rkbY0aFfeEGP4r7Gl4Yja6UgC'
ENV['RECAPTCHA_PRIVATE_KEY'] = '6Le4nNkSAAAAADdi-Bk3_bdPV5X-IkEWfHgsAV7e'

