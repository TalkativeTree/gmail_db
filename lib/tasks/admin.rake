namespace :admin do

  desc "Retrieve gmail messages for all Admin"
  task get_emails: :environment do
    Admin.all.each do |admin|
      EmailRetriever.fetch_emails(admin)
    end
  end

end
