module Pageflow
  module Admin
    class MembersTab < ViewComponent
      def build(entry)
        embedded_index_table(entry.memberships.includes(:user).references(:users),
                             blank_slate_text: I18n.t('pageflow.admin.entries.no_members')) do
          table_for_collection class: 'memberships', sortable: true, i18n: Pageflow::Membership do
            column :user, sortable: 'users.last_name', class: 'name' do |membership|
              if authorized? :read, membership.user
                link_to(membership.user.formal_name, admin_user_path(membership.user),
                        class: 'view_creator')
              else
                membership.user.full_name
              end
            end
            column :role,
                   sortable: 'pageflow_memberships.role',
                   title: I18n.t('activerecord.attributes.pageflow/membership.role') do |membership|
              span I18n.t(membership.role, scope: 'activerecord.values.pageflow/membership.role'),
                   class: "membership_role #{membership.role} tooltip_clue" do
                div I18n.t(membership.role,
                           scope: 'pageflow.admin.users.roles.entries.tooltip'),
                    class: 'tooltip_bubble'
              end
            end
            column :created_at, sortable: 'pageflow_memberships.created_at'
            column do |membership|
              if authorized?(:update, membership)
                link_to(I18n.t('pageflow.admin.users.edit_role'),
                        edit_admin_entry_membership_path(entry,
                                                         membership,
                                                         entity_type: :entry),
                        data: {
                          rel: "edit_entry_membership_#{membership.role}"
                        })
              end
            end
            column do |membership|
              if authorized?(:destroy, membership)
                link_to(I18n.t('pageflow.admin.entries.remove'),
                        admin_entry_membership_path(membership.entity, membership),
                        method: :delete,
                        data: {
                          confirm: I18n.t('active_admin.delete_confirmation'),
                          rel: "delete_membership_#{membership.role}"
                        })
              end
            end
          end
        end
        embedded_index_table(entry.invitations.includes(:user).references(:users),
                             blank_slate_text: I18n.t('pageflow.admin.entries.no_invited_users')) do
          table_for_collection class: 'invitations', sortable: true, i18n: Pageflow::Invitation do
            column :user, sortable: 'pageflow_invitations.last_name', class: 'name' do |invitation|
              if authorized? :read, invitation.user
                link_to(invitation.formal_name, admin_user_path(invitation.user),
                        class: 'view_creator')
              else
                invitation.full_name
              end
            end
            column :role,
                   sortable: 'pageflow_invitations.role',
                   title: I18n.t('activerecord.attributes.pageflow/membership.role') do |invitation|
              span I18n.t(invitation.role, scope: 'activerecord.values.pageflow/membership.role'),
                   class: "invitation_role #{invitation.role} tooltip_clue" do
                div I18n.t(invitation.role,
                           scope: 'pageflow.admin.users.roles.entries.tooltip'),
                    class: 'tooltip_bubble'
              end
            end
            column :created_at, sortable: 'pageflow_invitations.created_at'
            column do |invitation|
              if authorized?(:update, invitation)
                link_to(I18n.t('pageflow.admin.users.edit_role'),
                        edit_admin_entry_invitation_path(entry,
                                                         invitation,
                                                         entity_type: :entry),
                        data: {
                          rel: "edit_entry_invitation_#{invitation.role}"
                        })
              end
            end
            column do |invitation|
              if authorized?(:destroy, invitation)
                link_to(I18n.t('pageflow.admin.entries.remove'),
                        admin_entry_invitation_path(invitation.entity, invitation),
                        method: :delete,
                        data: {
                          confirm: I18n.t('active_admin.delete_confirmation'),
                          rel: "delete_invitation_#{invitation.role}"
                        })
              end
            end
          end
        end
        para text_node I18n.t('pageflow.admin.resource_tabs.account_editor_hint')
        if authorized?(:add_member_to, entry)
          add_membership_button_if_needed(current_user, entry, 'entry')
        end
      end
    end
  end
end
