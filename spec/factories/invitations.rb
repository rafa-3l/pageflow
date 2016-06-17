module Pageflow
  FactoryGirl.define do
    factory :invitation, class: Invitation do
      user
      association :entity, factory: :account
      role :member
      first_name 'John'
      last_name 'Doe'
      before(:create) do |invitation|
        if invitation.entity_type != 'Pageflow::Account' &&
           !invitation.user.accounts.include?(invitation.entity.account) &&
           !invitation.entity.account.nil?
          create(:invitation,
                 user: invitation.user,
                 entity: invitation.entity.account,
                 role: :member)
        end
      end
    end

    factory :entry_invitation, class: Invitation do
      user
      association :entity, factory: :entry
      role :previewer
      first_name 'John'
      last_name 'Doe'
      before(:create) do |invitation|
        if !invitation.user.accounts.include?(invitation.entity.account) &&
           !invitation.entity.account.nil?
          create(:invitation,
                 user: invitation.user,
                 entity: invitation.entity.account,
                 role: :member)
        end
      end
    end

    factory :account_invitation, class: Invitation do
      user
      association :entity, factory: :account
      role :member
      first_name 'John'
      last_name 'Doe'
    end
  end
end
