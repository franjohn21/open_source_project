class CreateBookmarks < ActiveRecord::Migration
  def change
    create_table :bookmarks do |t|
      t.string :name, :category
      t.integer :zipcode
      t.float :rating
      t.boolean :visited, default: false
      t.timestamps
    end
  end
end
