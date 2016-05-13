module Pageflow
  FactoryGirl.define do
    factory :membership, class: Membership do
      user
      association :entity, factory: :entry
      role 'previewer'
      after(:create) do |membership|
        unless membership.entity_type == 'Pageflow::Account' ||
               membership.user.accounts.include?(membership.entity.account) ||
               membership.entity.account == nil
          create(:membership,
                 user: membership.user,
                 entity: membership.entity.account,
                 role: 'member')
        end
      end
    end

    factory :entry_membership, class: Membership do
      user
      association :entity, factory: :entry
      role 'previewer'
      after(:create) do |membership|
        unless membership.user.accounts.include?(membership.entity.account) ||
               membership.entity.account == nil
          create(:membership,
                 user: membership.user,
                 entity: membership.entity.account,
                 role: 'member')
        end
      end
    end

    factory :account_membership, class: Membership do
      user
      association :entity, factory: :account
      role 'previewer'
    end
  end
end
