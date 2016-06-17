module Pageflow
  module Admin
    class UserAccountBadgeList < ViewComponent
      builder_method :user_account_badge_list

      def build(user)
        ul class: 'badge_list' do
          user_accounts(user).each do |membership|
            if authorized?(:see_badge_belonging_to, membership.entity)
              build_badge(membership)
            end
          end

          user_account_invitations(user).each do |invitation|
            if authorized?(:see_badge_belonging_to, invitation.entity)
              build_badge(invitation, ", #{I18n.t('activerecord.attributes.user.invited?')}")
            end
          end

          build_admin_badge if user.admin?
        end
      end

      private

      def user_accounts(user)
        Membership.where(user: user, entity_type: 'Pageflow::Account')
      end

      def user_account_invitations(user)
        Invitation.where(user: user, entity_type: 'Pageflow::Account')
      end

      def build_badge(admission, invitation_string = '')
        translation_scope = 'activerecord.values.pageflow/membership.role'
        li do
          if authorized?(:read, admission.entity)
            account_name_display = span(link_to(admission.entity.name,
                                                main_app.admin_account_path(admission.entity)),
                                        class: 'abbreviation')
            div class: 'tooltip' do
              account_name_display + " (#{I18n.t(admission.role, scope: translation_scope)}" <<
                invitation_string << ')'
            end
          else
            span(admission.entity.name, class: 'abbreviation')
          end
        end
      end

      def build_admin_badge
        li do
          span(I18n.t('pageflow.admin.users.roles.admin'), class: 'abbreviation')
        end
      end
    end
  end
end
