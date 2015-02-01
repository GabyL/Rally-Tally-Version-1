class AddCorrectTimeColumn < ActiveRecord::Migration
  def change
    add_column :events, :correct_time, :string
  end
end
