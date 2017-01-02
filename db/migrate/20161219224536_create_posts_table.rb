class CreatePostsTable < ActiveRecord::Migration[5.0]
  def change
  	create_table :posts do |t|
  		t.text :content
  		t.integer :post_id
  		t.integer :user_id
  	end
  end
end
