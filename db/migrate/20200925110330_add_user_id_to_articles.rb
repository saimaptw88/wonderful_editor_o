class AddUserIdToArticles < ActiveRecord::Migration[6.0]
  def up
    # change
    # add_reference :articles, :user, null: false, foreign_key: true
    add_reference :articles, :user, foreign_key: true
    change :user, null: false
  end
end
