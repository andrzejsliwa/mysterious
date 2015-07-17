class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.references :lead
      t.string :message
      t.string :details

      t.timestamps null: false
    end
  end
end
