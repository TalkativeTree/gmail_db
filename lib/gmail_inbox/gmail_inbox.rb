module EmailRetriever

  def fetch_emails(user)
    inbox = GmailInbox.new(user.email, user.gmail_password)
    messages = inbox.all(:all, after:  Net::IMAP.format_datetime(5.minutes.ago))
    EmailSaver.save(messages)
  end


  class GmailInbox
    require 'gmail'

    attr_accessor :gmail, :user

    def initialize(user_name, user_password)
      @user  = user_name
      @gmail = Gmail.new(user_name, user_password)
    end

    def received(key_or_opts = :all, opts={})
      gmail.mailbox('INBOX').emails(key_or_opts, opts)
    end

    def sent(key_or_opts = :all, opts={})
      gmail.mailbox('[Gmail]/Sent Mail').emails(key_or_opts, opts)
    end

    # all only returns INBOX and Sent Mail
    def all(key_or_opts = :all, opts={})
      process(received(key_or_opts, opts)) + process(sent(key_or_opts, opts))
    end

  end

  class EmailSaver
    require 'sanitize'

    class << self
      def process(messages)
        messages.each do |email|
          begin
            gmail_message = if defined?(GmailMessage)
                              GmailMessage.new
                            else
                              ActiveRecord.const_get("GmailMessage").new
                            end

            pp "email.date: #{email.date}"
            pp "email.uid: #{email.uid}"
            pp "email.boundary: #{email.boundary}"
            pp "email.to: #{email.to}"
            pp "email.from:  #{email.from}"
            pp "email.from:  #{from}"
            pp "email.cc: #{email.cc}"
            pp "email.bcc: #{email.bcc}"

            gmail_message.date = email.date
            gmail_message.uid = email.uid
            gmail_message.boundary = email.boundary
            gmail_message.to = email.to
            gmail_message.from = email.from[0] || @user
            gmail_message.cc = email.cc
            gmail_message.bcc = email.bcc
            gmail_message.raw_source = clean(email.raw_source)

            if gmail_message.save
              email.parts.each do |part|
                gmail_message.parts.create(content: clean(part.body))
              end
            end

          rescue => e
            Rails.logger.error "Error saving , will ignore: #{e}"
            pp "ERROR: #{e}"
            pp gmail_message
            next
          end
        end
      end

      def clean(source)
        body = source.force_encoding('iso-8859-1').encode("UTF-8")
        Sanitize.clean(body)
      end
    end
  end

end