class SentText < ActiveRecord::Migration
  def change
    add_column :events, :sent_text, :boolean
  end
end
