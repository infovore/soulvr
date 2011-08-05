#!/usr/bin/env ruby

require 'rubygems'
require 'mechanize'
require 'yaml'
require 'open-uri'
require 'nokogiri'

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

def read_mailbox(agent, url, name, matching_alt_text, no_match_string, match_string)
  puts "Grabbing #{name}..."
  mailbox = agent.get(url)
  
  mailbox_doc = Nokogiri::HTML(mailbox.body)
  messages = mailbox_doc.css("ul#mailbox ul.message")
  
  matching_messages = messages.select do |message|
    img = message.css("li img").first
    img.attributes['alt'].value == matching_alt_text
  end
  
  if matching_messages.any?
    matching_messages.each do |message|
      correspondent_string = message.css("li.correspondents").first.inner_text.strip
      name = correspondent_string.split(",").first.strip
      puts match_string.gsub("£", name)
    end
  else
    puts no_match_string
  end

  puts
end

def read_inbox(agent)
  read_mailbox(agent, "https://soulmates.guardian.co.uk/messages/inbox", "inbox", "You haven't read it", "No new messages in the inbox.", "£ has sent you a new message!")
end

def read_outbox(agent)
  read_mailbox(agent, "https://soulmates.guardian.co.uk/messages/outbox", "outbox", "Unread by them", "No unread messages that you've sent.", "£ has not read your message yet.")
end

if page.title == "Sign in to Soulmates - Guardian Soulmates"
  puts
  puts "Incorrect username or password. Check your creds.yml file, or log in to the website manually."
  puts
else
  read_outbox(agent)
  read_inbox(agent)
end