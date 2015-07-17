class CreateLeads < ActiveRecord::Migration
  def change
    create_table :leads do |t|
      t.string :phone
      t.string :full_name

      t.timestamps null: false
    end
  end
end
