module Pageflow
  class UserMailer < ActionMailer::Base
    include Resque::Mailer

    def invitation_signin(options)
      @user = User.find(options['user_id'])
      @password_token = options['password_token']

      I18n.with_locale(@user.locale) do
        headers('X-Language' => I18n.locale)
        mail(to: @user.email, subject: t('.subject'), from: Pageflow.config.mailer_sender)
      end
    end

    def invitation(options)
      @user = User.find(options['user_id'])
      @account_id = options['account_id']

      I18n.with_locale(@user.locale) do
        headers('X-Language' => I18n.locale)
        mail(to: @user.email, subject: t('.subject'), from: Pageflow.config.mailer_sender)
      end
    end
  end
end
