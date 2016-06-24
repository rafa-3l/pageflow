require 'spec_helper'

module Pageflow
  describe InvitedUser do
    it 'is valid without password' do
      user = InvitedUser.new(attributes_for(:valid_user,
                                            password: nil,
                                            password_confirmation: nil))

      expect(user).to be_valid
    end

    describe '#send_password_reset!' do
      it 'delivers password reset email' do
        user = create(:invited_user)

        expect(UserMailer).to receive(:invitation_signin)
          .with('user_id' => user.id, 'password_token' => kind_of(String))
          .and_return(double(deliver: true))

        user.send_password_reset!
      end

      it 'generates password reset token' do
        user = build(:invited_user)

        user.send_password_reset!

        expect(user.reset_password_token).to be_present
      end
    end

    describe '#save' do
      it 'sends password reset on creation' do
        user = build(:invited_user, password: nil)

        expect(UserMailer).to receive(:invitation_signin)
          .with('user_id' => kind_of(Numeric),
                'password_token' => kind_of(String))
          .and_return(double(deliver: true))

        user.save
      end

      it 'generates password reset token' do
        user = build(:invited_user, password: nil)

        user.save

        expect(user.reset_password_token).to be_present
      end

      it 'does not send password reset on update' do
        user = create(:invited_user, password: nil)

        expect(UserMailer).not_to receive(:invitation_signin)
        user.update_attributes(first_name: 'new name')
      end
    end
  end
end
