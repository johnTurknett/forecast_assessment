class AddLookupIdLookup < ActiveRecord::Migration[7.1]
  def change
    add_column :lookups, :lookup_id, :integer
  end
end
