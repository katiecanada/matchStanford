class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string    :firstname
      t.string    :middlename
      t.string    :lastname
      t.string    :email
      t.string    :choices
      t.string    :username
      t.integer   :doSplash, :default => 1

      t.timestamps
    end
  end
end
