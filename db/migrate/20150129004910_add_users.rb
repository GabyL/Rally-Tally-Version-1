class AddUsers < ActiveRecord::Migration

  def up
    create_table :users do |t|
      t.string :firstname
      t.string :lastname
      t.string :email
      t.string :username
      t.string :password
      t.string :phone
      t.timestamps
    end
  end

  def down
    drop_table :users
  end

end
