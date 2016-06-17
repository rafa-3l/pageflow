module Pageflow
  module Admin
    class UserEntriesTab < ViewComponent
      def build(user)
        embedded_index_table(user.memberships.on_entries.includes(:entry, entry: :account)
                              .accessible_by(Ability.new(current_user), :index),
                             blank_slate_text: t('pageflow.admin.users.no_entries')) do
          table_for_collection class: 'memberships', sortable: true, i18n: Pageflow::Membership do
            column :entry, sortable: 'pageflow_entries.title' do |membership|
              link_to(membership.entity.title, admin_entry_path(membership.entity))
            end
            column :role, sortable: 'pageflow_memberships.role' do |membership|
              span t(membership.role, scope: 'activerecord.values.pageflow/membership.role'),
                   class: "membership_role #{membership.role} tooltip_clue" do
                div t(membership.role, scope: 'pageflow.admin.users.roles.entries.tooltip'),
                    class: 'tooltip_bubble'
              end
            end
            column :account, sortable: 'pageflow_accounts.name' do |membership|
              if authorized?(:read, membership.entity.account)
                link_to(membership.entity.account.name,
                        admin_account_path(membership.entity.account))
              else
                membership.entity.account.name
              end
            end
            column :created_at, sortable: 'pageflow_memberships.created_at'
            column do |membership|
              if authorized?(:update, membership)
                link_to(t('pageflow.admin.users.edit_role'),
                        edit_admin_user_membership_path(user, membership, entity_type: :entry),
                        data: {
                          rel: "edit_entry_role_#{membership.role}"
                        })
              end
            end
            column do |membership|
              if authorized?(:destroy, membership)
                link_to(t('pageflow.admin.users.delete'),
                        admin_user_membership_path(user, membership),
                        method: :delete,
                        data: {
                          confirm: t('pageflow.admin.users.delete_entry_membership_confirmation'),
                          rel: "delete_entry_membership_#{membership.role}"
                        })
              end
            end
          end
        end
        embedded_index_table(user.invitations.on_entries.includes(:entry, entry: :account)
                              .accessible_by(Ability.new(current_user), :index),
                             blank_slate_text: t('pageflow.admin.users.no_entry_invitations')) do
          table_for_collection class: 'invitations', sortable: true, i18n: Pageflow::Invitation do
            column :entry, sortable: 'pageflow_entries.title' do |invitation|
              link_to(invitation.entity.title, admin_entry_path(invitation.entity))
            end
            column :role, sortable: 'pageflow_invitations.role' do |invitation|
              span t(invitation.role, scope: 'activerecord.values.pageflow/membership.role'),
                   class: "invitation_role #{invitation.role} tooltip_clue" do
                div t(invitation.role, scope: 'pageflow.admin.users.roles.entries.tooltip'),
                    class: 'tooltip_bubble'
              end
            end
            column :account, sortable: 'pageflow_accounts.name' do |invitation|
              if authorized?(:read, invitation.entity.account)
                link_to(invitation.entity.account.name,
                        admin_account_path(invitation.entity.account))
              else
                invitation.entity.account.name
              end
            end
            column :created_at, sortable: 'pageflow_invitations.created_at'
            column do |invitation|
              if authorized?(:update, invitation)
                link_to(t('pageflow.admin.users.edit_role'),
                        edit_admin_user_invitation_path(user, invitation, entity_type: :entry),
                        data: {
                          rel: "edit_entry_role_#{invitation.role}"
                        })
              end
            end
            column do |invitation|
              if authorized?(:destroy, invitation)
                link_to(t('pageflow.admin.users.delete'),
                        admin_user_invitation_path(user, invitation),
                        method: :delete,
                        data: {
                          confirm: t('pageflow.admin.users.delete_entry_invitation_confirmation'),
                          rel: "delete_entry_invitation_#{invitation.role}"
                        })
              end
            end
          end
          add_membership_button_if_needed(user, user, 'entry')
        end
      end
    end
  end
end
