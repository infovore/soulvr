class Outbox < Mailbox
  def initialize(html)
    self.name = "outbox"
    self.matching_alt_text = "Unread by them"
    self.no_match_string = "No unread messages in the outbox."
    self.match_string = "£ has not read your message yet."
    super
  end
end
