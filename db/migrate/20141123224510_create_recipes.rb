class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.text :title
      t.text :description
      t.string :cuisine
      t.text :ingredients
      t.text :instructions
      t.integer :time
      t.string :user_id
      t.boolean :grocery_list?, default: false
      t.text :imageURL

      t.timestamps
    end
  end
end
