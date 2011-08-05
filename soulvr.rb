#!/usr/bin/env ruby

require 'rubygems'
require 'mechanize'
require 'yaml'
require 'open-uri'

require 'lib/mailbox'
require 'lib/inbox'
require 'lib/outbox'

current_dir = File.expand_path(File.dirname(__FILE__))
creds = YAML.load_file("#{current_dir}/creds.yml")
username, password = creds["user"], creds["password"]

agent = Mechanize.new

page = agent.get("http://soulmates.guardian.co.uk/sign-in")

login_form = page.forms.first
login_form.username = username
login_form.password = password

puts "Logging in as #{username}"
puts
page = agent.submit(login_form)

if page.title == "Sign in to Soulmates - Guardian Soulmates"
  puts
  puts "Incorrect username or password. Check your creds.yml file, or log in to the website manually."
  puts
else
  puts "Getting outbox..."
  outbox_page = agent.get("https://soulmates.guardian.co.uk/messages/outbox")
  
  outbox = Outbox.new(outbox_page.body)
  if outbox.messages_to_display.any?
    outbox.messages_to_display.each {|m| puts m}
  else
    puts outbox.no_match_string
  end
  
  puts
  
  puts "Getting inbox..."
  inbox_page = agent.get("https://soulmates.guardian.co.uk/messages/inbox")
  
  inbox = Inbox.new(inbox_page.body)
  if inbox.messages_to_display.any?
    inbox.messages_to_display.each {|m| puts m}
  else
    puts inbox.no_match_string
  end
  puts
end