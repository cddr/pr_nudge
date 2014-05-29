class CreateGithubWebhooks < ActiveRecord::Migration
  def change
    create_table :github_webhooks do |t|
      t.column :github_event, :string, null: false
      t.column :pr_workflow_event, :string, null: false
      t.column :payload, :json, null: false
      t.column :username, :string, null: false
      t.timestamps
    end
  end
end
