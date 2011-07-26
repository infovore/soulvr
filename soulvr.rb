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
page = agent.submit(login_form)
puts "Grabbing inbox..."
inbox = agent.get("https://soulmates.guardian.co.uk/messages/inbox")
puts "Grabbing outbox..."
outbox = agent.get("https://soulmates.guardian.co.uk/messages/outbox")
puts

outbox_doc = Nokogiri::HTML(outbox.body)
sent_messages = outbox_doc.css("ul#mailbox ul.message")

unopened_messages = sent_messages.select do |message|
  img = message.css("li img").first
  img.attributes["alt"].value == "Unread by them"
end

if unopened_messages.any?
  unopened_messages.each do |message|
    name = message.css("li.correspondents").first.inner_text.strip
    puts "#{name} has not read your message yet."
  end
else
  puts "No unread messages that you've sent."
end

puts
puts

inbox_doc = Nokogiri::HTML(inbox.body)
received_messages = inbox_doc.css("ul#mailbox ul.message")

new_messages = received_messages.select do |message|
  img = message.css("li img").first
  img.attributes["alt"].value == "Unread by them"
end

if new_messages.any?
  new_messages.each do |message|
    name = message.css("li.correspondents").first.inner_text.strip
    puts "#{name} has sent you a new message!"
  end
else
  puts "No new messages in the inbox."
end
