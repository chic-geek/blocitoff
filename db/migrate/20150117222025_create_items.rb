class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.references :list, index: true

      t.timestamps null: false
    end
    add_foreign_key :items, :lists
  end
end
