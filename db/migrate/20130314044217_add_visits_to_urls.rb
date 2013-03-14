class AddVisitsToUrls < ActiveRecord::Migration
  def change
    add_column :urls, :visits, :integer, default: 0
  end
end
