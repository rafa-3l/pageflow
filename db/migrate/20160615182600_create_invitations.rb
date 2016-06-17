class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :pageflow_invitations do |t|
      t.integer :user_id
      t.integer :entity_id
      t.string :first_name
      t.string :last_name
      t.datetime :created_at
      t.datetime :updated_at
      t.string :entity_type
      t.string :role, default: 'editor', null: false
    end

    add_index :pageflow_invitations,
              [:entity_id],
              name: 'index_pageflow_invitations_on_entity_id',
              using: :btree

    add_index :pageflow_invitations,
              [:user_id],
              name: 'index_pageflow_invitations_on_user_id',
              using: :btree
  end
end
