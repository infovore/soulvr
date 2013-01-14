class Inbox < Mailbox
  def initialize(html)
    self.name = "inbox"
    self.matching_alt_text = "You haven't read it"
    self.no_match_string = "No new messages in the inbox."
    self.match_string = "~ has sent you a new message!"
    super
  end
end
