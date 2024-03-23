class CreateLookups < ActiveRecord::Migration[7.1]
  def change
    create_table :lookups do |t|
      t.integer :zipcode

      t.timestamps
    end
  end
end
