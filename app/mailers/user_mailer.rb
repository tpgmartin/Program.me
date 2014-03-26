class UserMailer < ActionMailer::Base
  default from: "help@program.me"

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password Reset"
  end

  def signup_confirmation(user)
    @user = user
    mail to: user.email, subject: "Sign Up Confirmation"
  end

  def invite_email(invitation, signup_url)
    @user = invitation.sender
    @sign_url  = signup_url
    mail to: invitation.recipient_email, subject: "Signup Invitation"
  end

  def event_creation(user, event, event_url)
    @user = user
    @event = event
    @event_url = event_url
    mail(to: event.recipient_email, subject: "Lesson Created")
  end

  def upcoming_events_reminder(user, events)
    
  end

  # def student_parent_signup(user, token)
  #   @user = user
  #   @tutor = user.token
  # end

  # def invitation(invitation, signup_url)
  #   subject    'Invitation'
  #   recipients invitation.recipient_email
  #   from       'foo@example.com'
  #   body       :invitation => invitation, :signup_url => signup_url
  #   invitation.update_attribute(:sent_at, Time.now)
  # end
end
