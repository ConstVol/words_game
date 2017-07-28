class CreatePhrases < ActiveRecord::Migration[5.1]
  def change
    create_table :phrases do |t|
      t.string :user_name
      t.string :last_user
      t.text :words, array: true, default: []
    end
  end
end
