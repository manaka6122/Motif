class CreateTeams < ActiveRecord::Migration[6.1]
  def change
    create_table :teams do |t|
      t.references "customer", null: false, foreign_key: true
      t.string "name", null: false
      t.string "address", null: false
      t.text "introduction", null: false

      t.timestamps
    end
  end
end
