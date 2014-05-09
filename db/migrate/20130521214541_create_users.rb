class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string    :firstName
      t.string    :middleName
      t.string    :lastName
      t.string    :email
      t.string    :choices
      t.string    :username
      t.boolean   :doSplash, :default => 1

      t.timestamps
    end
  end
end
