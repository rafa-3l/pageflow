module Pageflow
  class InvitationPolicy
    class Scope
      include Pageflow::AdmissionPolicyScopeMixin

      private

      def table_name
        'pageflow_invitations'
      end

      def managed_ids(user)
        user.invitations.on_accounts.where(role: 'manager').map(&:entity_id)
      end
    end
    include Pageflow::AdmissionPolicyMixin
  end
end
