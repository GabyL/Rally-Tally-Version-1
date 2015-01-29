class AddVotes < ActiveRecord::Migration

  def up
    create_table :votes do |t|
      t.belongs_to :event, index: true
      t.belongs_to :guest, index: true
      t.belongs_to :venue, index: true
      t.timestamps
    end
  end

  def down
    drop_table :votes
  end

end
