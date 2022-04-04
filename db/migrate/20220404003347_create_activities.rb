class CreateActivities < ActiveRecord::Migration[6.1]
  def change
    create_table :activities do |t|
      t.integer "customer_id", null: false
      t.integer "team_id", null: false
      t.string "title", null: false
      t.text "content", null: false
      t.date "activity_on", null: false
      t.integer "status", default: 0, null: false

      t.timestamps
    end
  end
end
