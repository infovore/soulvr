require 'nokogiri'
class Mailbox
  attr_accessor :matching_alt_text
  attr_accessor :no_match_string
  attr_accessor :match_string
  attr_accessor :name
  attr_accessor :messages_to_display
  
  def initialize(html)
    self.messages_to_display = []
    mailbox_doc = Nokogiri::HTML(html)
    messages = mailbox_doc.css("ul#mailbox ul.message")

    matching_messages = messages.select do |message|
      img = message.css("li img").first
      img.attributes['alt'].value == matching_alt_text
    end

    if matching_messages.any?
      matching_messages.each do |message|
        correspondent_string = message.css("li.correspondents").first.inner_text.strip
        name = correspondent_string.split(",").first.strip
        self.messages_to_display << match_string.gsub("£", name)
      end
    end
  end
end
