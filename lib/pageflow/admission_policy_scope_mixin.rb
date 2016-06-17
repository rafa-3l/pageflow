module Pageflow
  module AdmissionPolicyScopeMixin
    extend ActiveSupport::Concern
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
      @table_name = table_name
    end

    def indexable
      if user.admin?
        scope.all
      else
        scope.where(permissions_appropriate).where(admission_is_present)
      end
    end

    private

    def sanitize_sql_array(array)
      ActiveRecord::Base.send(:sanitize_sql_array, array)
    end

    def permissions_appropriate
      sanitize_sql_array(["#{@table_name}.entity_type = 'Pageflow::Account' AND " \
                          "#{@table_name}.entity_id IN (:managed_account_ids) OR " \
                          "#{@table_name}.entity_type = 'Pageflow::Entry' AND " \
                          "#{@table_name}.entity_id IN (:common_entry_ids) OR "\
                          "#{@table_name}.user_id = :user_id",
                          managed_account_ids: managed_account_ids,
                          common_entry_ids: common_entry_ids,
                          user_id: @user.id])
    end

    def managed_account_ids
      managed_ids(user)
    end

    def common_entry_ids
      EntryPolicy::Scope.new(user, Entry).resolve.map(&:id)
    end

    def admission_is_present
      "#{@table_name}.entity_id IS NOT NULL"
    end
  end
end
