module Pageflow
  class Membership < ActiveRecord::Base
    include Pageflow::AdmissionMixin
    belongs_to :entry,
               -> { where(pageflow_memberships: {entity_type: 'Pageflow::Entry'}) },
               foreign_key: 'entity_id'
    belongs_to :account,
               -> { where(pageflow_memberships: {entity_type: 'Pageflow::Account'}) },
               foreign_key: 'entity_id'

    validate :account_membership_exists, if: :on_entry?

    after_create do
      entity.increment(:users_count)
    end

    after_destroy do
      entity.decrement(:users_count)
    end

    private

    def account_membership_exists
      unless user.accounts.include?(entity.account)
        errors[:base] << 'Entry Membership misses presupposed Membership on account of entry'
      end
    end
  end
end
