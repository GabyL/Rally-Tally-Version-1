class SetDefaultToSentText < ActiveRecord::Migration
  def change
    change_column :events, :sent_text, :boolean, default: false
  end
end
