class CreateBookmarks < ActiveRecord::Migration
  def change
    create_table :bookmarks do |t|
      t.string :name, :neighborhood, :yelp_id
      t.integer :reviews
      t.float :rating
      t.boolean :visited, default: false
      t.timestamps
    end
  end
end
