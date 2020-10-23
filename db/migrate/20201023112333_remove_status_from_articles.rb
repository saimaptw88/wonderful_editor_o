class RemoveStatusFromArticles < ActiveRecord::Migration[6.0]
  def change
    remove_column :articles, :status, :string
    remove_column :articles, :, :integer
  end
end
