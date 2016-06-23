module Pageflow
  # Specialized User class containing invitation logic used by in the
  # users admin.
  class InvitedUser < User
    attr_accessor :initial_account, :initial_role

    before_create :prepare_password_reset
    after_create :send_password_reset

    def send_invitation!
      prepare_password_reset
      save(validate: false)
      send_password_reset
    end

    private

    def prepare_password_reset
      @token = generate_password_reset_token
    end

    def generate_password_reset_token
      raw, enc = Devise.token_generator.generate(self.class, :reset_password_token)

      self.reset_password_token = enc
      self.reset_password_sent_at = Time.now.utc

      raw
    end

    def password_required?
      false
    end

    def send_password_reset
      UserMailer.invitation_signin('user_id' => id, 'password_token' => @token).deliver
    end
  end
end
