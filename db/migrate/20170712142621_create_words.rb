class CreateWords < ActiveRecord::Migration[5.1]
  def change
    create_table :words do |t|
      t.belongs_to :phrase, index: true
      t.string :user_name
      t.string :text
      t.string :time
    end
  end
end
