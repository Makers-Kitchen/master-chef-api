class CreatePins < ActiveRecord::Migration[5.0]
  def change
    create_table :pins do |t|
      t.string :user_id
      t.string :user_name
      t.string :location

      t.timestamps
    end
  end
end
