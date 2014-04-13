class WelcomeController < ApplicationController
  def index
  end

  def contact_us    
    UserMailer.signup_confirmation(@user).deliver

  end
end
