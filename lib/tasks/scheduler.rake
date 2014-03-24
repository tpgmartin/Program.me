require 'rake'

desc "Send reminder emails to all users with unread messages"
task :send_reminder_emails => :environment do  # Task defined in rake file
    User.all.each do |user|  # Defined in User.rb
      if user.unreads.count
        if user.created_at < Time.now - 20.hours &&  user.reminder_email_sent_at < Time.now - 20.hours
          begin
            Rails.logger.info "UNREAD MESSAGES REMINDER EMAIL: emailing #{user.email}"
          UserMailer.unreads_reminder(user).deliver # Need to define this in UserMailer
          user.update_attribute :reminder_email_sent_at, Time.now
        rescue Exception => e
          Rails.logger.error "ERROR! #{e}"
        end
      end
    end
  end
end

desc "Say Hello!"
task :say_hello => :environment do
  puts "HELLO!"
end