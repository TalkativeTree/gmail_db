class GmailInbox
  attr_accessor :gmail, :user

  def initialize(user_name, user_password)
    @user  = user_name
    @gmail = Gmail.new(user_name, user_password)
  end

  def received
    @received ||= gmail.mailbox('INBOX').emails
    @received
  end

  def sent
    @sent ||= gmail.mailbox('[Gmail]/Sent Mail').emails
    @sent
  end

  def fetch(group)
    case group
    when :all
      process(received)
      process(sent)
    when :recieved
      process(recieved)
    when :sent
      process(sent)
    end
  end

  def process(messages)
    messages.each do |email|
      new_mail = Email.new
      new_mail.uid = email.uid
      new_mail.boundary = email.boundary
      email.parts.each{|part| new_mail.parts.create(content: part.body)}
      new_mail.to = email.to
      new_mail.sender = email.sender || @user
      new_mail.cc = email.cc
      new_mail.bcc = email.bcc
      new_mail.raw_source = new_mail.raw_source

      new_mail.save
    end
  end
end