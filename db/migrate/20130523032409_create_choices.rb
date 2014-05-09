class CreateChoices < ActiveRecord::Migration
  def change
    create_table :choices do |t|
      t.column :from_id, :integer
      t.column :to_id, :integer
      t.column :rank, :integer

      t.timestamps
    end
  end
end
