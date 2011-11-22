#!/usr/bin/env ruby

require 'rubygems'
require 'yaml'

require File.dirname(__FILE__) + '/lib/mailbox'
require File.dirname(__FILE__) + '/lib/inbox'
require File.dirname(__FILE__) + '/lib/outbox'
require File.dirname(__FILE__) + '/lib/soulmates'

current_dir = File.expand_path(File.dirname(__FILE__))
creds = YAML.load_file("#{current_dir}/creds.yml")
username, password = creds["user"], creds["password"]

begin
  soulmates = Soulmates.new(username,password)

  puts "Outbox:"
  if soulmates.outbox.messages_to_display.any?
    soulmates.outbox.messages_to_display.each {|m| puts m}
  else
    puts soulmates.outbox.no_match_string
  end
  
  puts
  
  puts "Inbox"
  if soulmates.inbox.messages_to_display.any?
    soulmates.inbox.messages_to_display.each {|m| puts m}
  else
    puts soulmates.inbox.no_match_string
  end
  puts
rescue SoulmatesLoginError
  puts "Login details incorrect"
end