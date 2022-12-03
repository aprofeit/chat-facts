class CreateLeaderboards < ActiveRecord::Migration[7.0]
  def change
    create_table :leaderboards do |t|
      t.string :token

      t.timestamps
    end

    add_index :leaderboards, :token, unique: true
  end
end
