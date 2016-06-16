class AddInvitedUsersCountToAccount < ActiveRecord::Migration
  def self.up
    add_column :pageflow_accounts, :invited_users_count, :integer, default: 0, null: false
    add_column :pageflow_entries, :invited_users_count, :integer, default: 0, null: false

    execute(<<-SQL)
      UPDATE pageflow_accounts SET invited_users_count = (
        SELECT COUNT(*)
        FROM pageflow_invitations
        WHERE pageflow_invitations.entity_id = pageflow_accounts.id AND
        pageflow_invitations.entity_type = 'Pageflow::Account'
      );
    SQL

    execute(<<-SQL)
      UPDATE pageflow_entries SET invited_users_count = (
        SELECT COUNT(*)
        FROM pageflow_invitations
        WHERE pageflow_invitations.entity_id = pageflow_entries.id AND
        pageflow_invitations.entity_type = 'Pageflow::Entry'
      );
    SQL
  end

  def self.down
    remove_column :pageflow_accounts, :invited_users_count
    remove_column :pageflow_entries, :invited_users_count
  end
end
