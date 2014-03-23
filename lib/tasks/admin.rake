
class GmailInbox
  require 'gmail'
  require 'sanitize'

  attr_accessor :gmail, :user

  def initialize(user_name, user_password)
    @user  = user_name
    @gmail = Gmail.new(user_name, user_password)
  end

  def received(key_or_opts = :all, opts={})
    @received ||= gmail.mailbox('INBOX').emails(key_or_opts, opts)
    @received
  end

  def sent(key_or_opts = :all, opts={})
    @sent ||= gmail.mailbox('[Gmail]/Sent Mail').emails(key_or_opts, opts)
    @sent
  end

  def save(group = :all, key_or_opts = :all, opts={})
    pp group
    pp opts
    pp key_or_opts
    case group
    when :all
      puts "processing"
      process(received(key_or_opts, opts))
      process(sent(key_or_opts, opts))
    when :recieved
      process(recieved(key_or_opts, opts))
    when :sent
      process(sent(key_or_opts, opts))
    end
  end

  def process(messages)
    messages.each do |email|
      begin
        gmail_message = if defined?(GmailMessage)
                          GmailMessage.new
                        else
                          ActiveRecord.const_get("GmailMessage").new
                        end

        pp "email.date: #{email.date}"
        gmail_message.date = email.date
        pp "email.uid: #{email.uid}"
        gmail_message.uid = email.uid
        pp "email.boundary: #{email.boundary}"
        gmail_message.boundary = email.boundary
        pp "email.to: #{email.to}"
        gmail_message.to = email.to
        pp "email.from:  #{email.from}"
        from = email.from[0] || @user
        pp "email.from:  #{from}"
        gmail_message.from = from
        pp "email.cc: #{email.cc}"
        gmail_message.cc = email.cc
        pp "email.bcc: #{email.bcc}"
        gmail_message.bcc = email.bcc
        body = email.raw_source.force_encoding('iso-8859-1').encode("UTF-8")
        body = Sanitize.clean(body)
        gmail_message.raw_source = body

        if gmail_message.save
          email.parts.each do |part|
            content = part.body.raw_sourceforce_encoding('iso-8859-1').encode("UTF-8")
            content = Sanitize.clean(body)
            gmail_message.parts.create(content: content)
          end
        end

      rescue => e
        Rails.logger.warn "Error saving , will ignore: #{e}"
        pp "ERROR MOTHER FUCKER"
        pp gmail_message
        next
      end
    end
  end
end


namespace :admin do

  desc "Retrieve gmail messages for all Admin"
  task get_emails: :environment do

    Admin.all.each do |admin|
      email = admin.email
      password = admin.gmail_password

      inbox = GmailInbox.new(email, password)
      inbox.save(:all, :all, after:  Net::IMAP.format_datetime(300.minutes.ago))
    end
  end

end
