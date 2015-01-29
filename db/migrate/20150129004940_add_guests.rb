class AddGuests < ActiveRecord::Migration

  def up
    create_table :guests do |t|
      t.belongs_to :event, index: true
      t.string :name
      t.string :phone
      t.timestamps
    end
  end

  def down
    drop_table :guests
  end

end
