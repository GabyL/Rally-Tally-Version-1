class AddDeclineColumn < ActiveRecord::Migration
  def change
    add_column :guests, :decline, :boolean, default: false
  end
end
