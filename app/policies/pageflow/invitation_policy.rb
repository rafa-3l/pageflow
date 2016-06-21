module Pageflow
  class InvitationPolicy
    class Scope
      include Pageflow::AdmissionPolicyScopeMixin

      private

      def table_name
        'pageflow_invitations'
      end
    end
    include Pageflow::AdmissionPolicyMixin
  end
end
