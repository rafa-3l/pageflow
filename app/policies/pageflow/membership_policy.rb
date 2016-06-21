module Pageflow
  class MembershipPolicy
    class Scope
      include Pageflow::AdmissionPolicyScopeMixin

      @table_name = 'pageflow_memberships'

      private

      def table_name
        'pageflow_memberships'
      end
    end
    include Pageflow::AdmissionPolicyMixin
  end
end
