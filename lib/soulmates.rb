require 'mechanize'

class SoulmatesLoginError < StandardError
end

class Soulmates
  attr_reader :inbox, :outbox
  
  def initialize(username,password)
    agent = Mechanize.new
    
    page = agent.get("http://soulmates.guardian.co.uk/sign-in")

    login_form = page.forms.first
    login_form.username = username
    login_form.password = password

    page = agent.submit(login_form)

    if page.title == "Sign in to Soulmates - Guardian Soulmates"
      raise SoulmatesLoginError
    else
      # populate inboxes
      outbox_page = agent.get("https://soulmates.guardian.co.uk/messages/outbox")
      @outbox = Outbox.new(outbox_page.body)
      
      inbox_page = agent.get("https://soulmates.guardian.co.uk/messages/inbox")
      @inbox = Inbox.new(inbox_page.body)
      self # return self
    end
  end
end