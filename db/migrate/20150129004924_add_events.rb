class AddEvents < ActiveRecord::Migration

  def up
    create_table :events do |t|
      t.belongs_to :user, index: true
      t.string :title
      t.datetime :time
      t.timestamps
    end
  end

  def down
    drop_table :events
  end

end
