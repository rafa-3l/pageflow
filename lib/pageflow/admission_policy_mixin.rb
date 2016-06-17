module Pageflow
  module AdmissionPolicyMixin
    extend ActiveSupport::Concern

    def initialize(user, admission)
      @user = user
      @admission = admission
    end

    def create?
      if @admission.entity_type == 'Pageflow::Account'
        create_for_account?
      else
        create_for_entry?
      end
    end

    def edit_role?
      if @admission.entity_type == 'Pageflow::Account'
        edit_role_on_account?
      else
        edit_role_on_entry?
      end
    end

    def destroy?
      if @admission.entity_type == 'Pageflow::Account'
        destroy_for_account?
      else
        destroy_for_entry?
      end
    end

    private

    def create_for_entry?
      EntryPolicy.new(@user, @admission.entity).add_member_to? &&
        @admission.user.accounts.include?(@admission.entity.account)
    end

    def create_for_account?
      AccountPolicy.new(@user, @admission.entity).add_member_to?
    end

    def edit_role_on_entry?
      @user.admin? ||
        EntryPolicy.new(@user, @admission.entity).edit_role_on?
    end

    def edit_role_on_account?
      @user.admin? ||
        AccountPolicy.new(@user, @admission.entity).edit_role_on?
    end

    def destroy_for_entry?
      @user.admin? ||
        EntryPolicy.new(@user, @admission.entity).destroy_admission_on?
    end

    def destroy_for_account?
      @user.admin? ||
        AccountPolicy.new(@user, @admission.entity).destroy_admission_on?
    end
  end
end
