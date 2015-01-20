class ForgotPasswordControl < Hello::AbstractControl
  
  alias :forgot_password :entity

  def success
    @credential = forgot_password.credential

    reset_token_and_deliver_email if should_reset_password_token?

    c.respond_to do |format|
      format.html { c.redirect_to c.hello.after_forgot_path }
      format.json { c.render json: {sent: true}, status: :created }
    end
  end

  def failure
    # SUGGESTION: register failed attempt

    c.respond_to do |format|
      format.html { c.render :forgot }
      format.json { c.render json: forgot_password.errors, status: :unprocessable_entity }
      # # To falsy show that the email was sent, please use the code below instead
      # format.html { c.redirect_to c.hello.after_forgot_path }
      # format.json { c.render json: {sent: true}, status: :created }
    end
  end





  private

  def reset_token_and_deliver_email
    token  = @credential.reset_password_token
    url    = c.hello.reset_token_url(token)
    Hello::RegistrationMailer.forgot_password(@credential, url).deliver
  end

  def should_reset_password_token?
    true
    # SUGGESTION: Don't let users request a new password more than once a week
    # past_or_never?(@credential.password_token_digested_at, 7.days.ago)
  end

      # def past_or_never?(time1, time2)
      #   time1.blank? || (time1 < time2)
      # end

end
