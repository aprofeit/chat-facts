class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.datetime :sent_at, null: false
      t.text :content, null: false
      t.string :type, null: false
      t.boolean :is_unsent, null: false
      t.boolean :is_taken_down, null: false
      t.json :bumped_message_metadata

      t.timestamps
    end
  end
end
