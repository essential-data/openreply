class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.string :text
      t.references :rating, index: true
      t.boolean :ignored_rating
      t.timestamps
    end
  end
end
