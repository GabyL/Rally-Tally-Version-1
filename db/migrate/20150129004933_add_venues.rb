class AddVenues < ActiveRecord::Migration

  def up
    create_table :venues do |t|
      t.belongs_to :event, index: true
      t.string :name
      t.string :address
      t.string :url
    end
  end

  def down
    drop_table :venues
  end

end
