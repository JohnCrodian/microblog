class AddUsernameToPostTable < ActiveRecord::Migration[5.0]
  def change
  	add_column :posts, :user_name, :text
  end
end
