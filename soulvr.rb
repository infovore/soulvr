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
  puts soulmates.outbox.messages_string_formatted
  puts
  
  puts "Inbox"
  puts soulmates.inbox.messages_string_formatted
  puts
  
rescue SoulmatesLoginError
  puts "Login details incorrect"
end