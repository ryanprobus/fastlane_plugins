require 'mechanize'
require 'logger'

@website = 'community.good.com'

agent = Mechanize.new
# additionally configure logger
agent.log = Logger.new "mechanize.log"
# to set proxy
# agent.set_proxy('localhost', '8000')

login_page = agent.get "https://#{@website}/login.jspa"
puts "after agent.get, got a #{login_page.class.name}"
login_page.methods.each do |instance_method|
  puts "login_page instance method: #{instance_method.to_s}"
end
puts "login_page content: \n#{login_page.content}"

login_form = login_page.form
next_login_page = login_form.submit()
puts next_login_page.content
next_login_form = next_login_page.form

puts "next_login_form fields"
next_login_form.fields.each do |field|
  puts field.name
end

email_field = next_login_form.field_with(name: "IDToken1")
# => #<Mechanize::Form::Field:0x007ff86352fdb0>
password_field = next_login_form.field_with(name: "IDToken2")

email_field.value = "lyndsey.ferguson@appian.com"
password_field.value = "u2EZCjfnfzXskt9"

loggedin_validated_page = next_login_form.submit()
puts loggedin_validated_page.form
logged_in_validated_form = loggedin_validated_page.form

logged_in_page = logged_in_validated_form.submit()

downloads_page = agent.get("https://community.good.com/community/gdn/resources/downloads")

download_authed_page = downloads_page.form.submit().form.submit()
File.open(File.expand_path('~/Desktop/mechanize.log'), 'w') { |file| file.write(download_authed_page.body) }
