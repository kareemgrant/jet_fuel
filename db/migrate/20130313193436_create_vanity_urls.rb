class CreateVanityUrls < ActiveRecord::Migration
  def change
    create_table :vanity_urls do |t|
      t.string :base
      t.references :user
      t.timestamps
    end
  end
end
