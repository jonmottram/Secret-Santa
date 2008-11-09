class XmasMailer < ActionMailer::Base

  def forgot_password(user, sent_at = Time.now)
    @subject    = 'Forgotten password'
    @body['user']   = user
    @recipients = user.email
    @from       = 'Mottram Adults Secret Santa'
    @sent_on    = sent_at
    @headers    = {}
  end
end
