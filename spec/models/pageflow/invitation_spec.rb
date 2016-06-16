require 'spec_helper'

module Pageflow
  describe Membership do
    describe 'invited_users_count callback' do
      it 'updates account attribute upon Invitation.create on account' do
        account = create(:account)

        expect do
          create(:invitation, entity: account)
        end.to change { account.invited_users_count }.by(1)
      end

      it 'updates entry attribute upon Invitation.create on entry' do
        entry = create(:entry)

        expect do
          create(:entry_invitation, entity: entry)
        end.to change { entry.invited_users_count }.by(1)
      end

      it 'updates account attribute upon Invitation.destroy on account' do
        account = create(:account)
        invitation = create(:invitation, entity: account)

        expect do
          invitation.destroy
        end.to change { account.invited_users_count }.by(-1)
      end

      it 'updates entry attribute upon Invitation.destroy on entry' do
        entry = create(:entry)
        invitation = create(:entry_invitation, entity: entry)

        expect do
          invitation.destroy
        end.to change { entry.invited_users_count }.by(-1)
      end
    end
  end
end
