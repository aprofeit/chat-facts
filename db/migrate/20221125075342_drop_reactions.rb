class DropReactions < ActiveRecord::Migration[7.0]
  def change
    drop_table :reactions
  end
end
