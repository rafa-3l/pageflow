module Pageflow
  class Invitation < ActiveRecord::Base
    include Pageflow::AdmissionMixin
    belongs_to :entry,
               -> { where(pageflow_invitations: {entity_type: 'Pageflow::Entry'}) },
               foreign_key: 'entity_id'
    belongs_to :account,
               -> { where(pageflow_invitations: {entity_type: 'Pageflow::Account'}) },
               foreign_key: 'entity_id'
    validate :account_membership_or_invitation_exists, if: :on_entry?
    validates :first_name, :last_name, presence: true
    scope :by_user, ->(user) { where(user_id: user) }

    after_create do
      entity.increment(:invited_users_count)
      send_invitation!
    end

    after_destroy do
      entity.decrement(:invited_users_count)
    end

    def full_name
      [first_name, last_name] * ' '
    end

    def formal_name
      [last_name, first_name] * ', '
    end

    def turn_into_membership
      ActiveRecord::Base.transaction do
        Membership.create!({user: user,
                            name: full_name,
                            entity_id: entity_id,
                            entity_type: entity_type,
                            role: role.to_sym})

        destroy
      end
    end

    def self.turn_into_memberships
      all.each(&:turn_into_membership)
    end

    def send_invitation!
      UserMailer.invitation('user_id' => user_id, 'account_id' => entity_id).deliver if on_account?
    end

    private

    def account_membership_or_invitation_exists
      unless user.accounts.include?(entity.account) || user.invited_accounts.include?(entity.account)
        errors[:base] << 'Entry Membership misses presupposed Membership on account of entry'
      end
    end
  end
end
