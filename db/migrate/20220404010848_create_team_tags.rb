class CreateTeamTags < ActiveRecord::Migration[6.1]
  def change
    create_table :team_tags do |t|
      t.references "team", foreign_key: true
      t.references "tag", foreign_key: true

      t.timestamps
    end
  end
end
