module Pageflow
  module FoldersHelper
    def collection_for_folders(current_account, current_folder_id = nil)
      accounts = Policies::AccountPolicy::Scope.new(current_user, Pageflow::Account)
                 .entry_creatable.includes(:folders).where('pageflow_folders.id IS NOT NULL')
                 .order(:name, 'pageflow_folders.name')

      option_groups_from_collection_for_select(accounts,
                                               :folders,
                                               :name,
                                               :id,
                                               :name,
                                               selected: current_folder_id,
                                               disabled: disabled_ids(accounts, current_account))
    end

    def jquery_for_disabling_on_change
      %|$('option[value=""]').prop('selected', 'selected')
        var account = $(this).find('option:selected').text();
        $('#entry_folder_input').val(0).find('optgroup').each(function(){
          var optgroup_account = this.label,
          isCorrectAccount = (optgroup_account === account);
          $(this).children('option').each(function(){
            var $option = $(this);
            $option.prop('disabled', !isCorrectAccount);
          });
        });|
    end

    private

    def disabled_ids(accounts, current_account)
      folders_array = accounts.map(&:folders).to_a

      folders_array.delete_if do |account_folders|
        account_folders[0][:account_id] == current_account.id
      end

      folders_array.map(&:to_a).map do |account_folders|
        account_folders.map(&:id)
      end.flatten
    end
  end
end
