require 'rake'

desc "Send reminder emails to all users with unread messages"
task :send_reminder_emails => :environment do  # Task defined in rake file
    Reading.all.each do |reading|  # Defined in User.rb
      user = User.where(id: reading.user_id)
      event = Event.where(id: reading.event_id)
      if event.created_at < Time.now - 20.hours  &&  user.reminder_email_sent_at < Time.now - 20.hours || user.reminder_email_sent_at = nil
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

desc "Send lesson reminder emails to users"
task :send_lesson_reminder => :environment do
  Event.all.each do |event|
    event.users.each do |user|
      if event.start_time < Time.now + 20.hours
        begin
          Rails.logger.info "LESSON REMINDER: emailing #{user.email}"
          UserMailer.lesson_reminder(user, event).deliver
        rescue Exception => e
          Rails.logger.error "ERROR! #{e}"
        end
      end
    end
  end
end

desc "Send feedback reminder emails to users"
task :send_feedback_reminder => :environment do
  Event.all.each do |event|
    event.users.each do |user|
      if event.end_time < Time.now
        begin
          Rails.logger.info "FEEDBACK REMINDER: emailing #{user.email}"
          UserMailer.feedback_reminder(user, event).deliver
        rescue Exception => e
          Rails.logger.error "ERROR! #{e}"
        end
      end
    end
  end
end

desc "This task is called by the Heroku scheduler add-on"
task :cheery_greeting => :environment do
  puts "Greeting in 1...2...3"
  User.where(id: 1)[0].greet
  puts "done."
end


desc "Say Hello!"
task :say_hello => :environment do
  puts "HELLO!"
end