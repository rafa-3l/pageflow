module Pageflow
  module Admin
    class EntryUserBadgeList < ViewComponent
      builder_method :entry_user_badge_list

      def build(entry)
        ul class: 'badge_list' do
          entry_users(entry).each do |membership|
            build_membership_badge(membership)
          end

          entry_invited_users(entry).each do |invitation|
            build_invitation_badge(invitation)
          end
        end
      end

      private

      def entry_users(entry)
        Membership.where(entity: entry)
      end

      def entry_invited_users(entry)
        Invitation.where(entity: entry)
      end

      def build_membership_badge(membership)
        role_string =
          " (#{I18n.t(membership.role, scope: 'activerecord.values.pageflow/membership.role')})"
        build_badge(membership.user, role_string, membership)
      end

      def build_invitation_badge(invitation)
        role_string =
          " (#{I18n.t(invitation.role, scope: 'activerecord.values.pageflow/membership.role')}"\
          ", #{I18n.t('activerecord.attributes.user.invited?')})"
        build_badge(invitation, role_string, invitation)
      end

      def build_badge(name_bearer, role_string, admission)
        li do
          span(user_initials(name_bearer), class: 'abbreviation')
          div class: 'tooltip' do
            if authorized?(:read, admission.user)
              link_to(name_bearer.full_name, admin_user_path(admission.user)) + role_string
            else
              span class: 'name' do
                name_bearer.full_name + role_string
              end
            end
          end
        end
      end

      def user_initials(name_bearer)
        name_bearer.first_name[0] + name_bearer.last_name[0]
      end
    end
  end
end
