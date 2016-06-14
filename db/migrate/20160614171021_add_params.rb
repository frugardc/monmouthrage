class AddParams < ActiveRecord::Migration
  def up
    add_column :impressions, :params, :string
  end

  def down
    remove_column :impressions, :params
  end
end
