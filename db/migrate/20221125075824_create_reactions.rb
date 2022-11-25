class CreateReactions < ActiveRecord::Migration[7.0]
  def change
    create_table :reactions do |t|
      t.belongs_to :message, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true
      t.string :content

      t.timestamps
    end
  end
end
