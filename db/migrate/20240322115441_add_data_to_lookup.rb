class AddDataToLookup < ActiveRecord::Migration[7.1]
  def change
    add_column :lookups, :data, :text
  end
end
