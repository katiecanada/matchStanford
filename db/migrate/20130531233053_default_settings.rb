class DefaultSettings < ActiveRecord::Migration
  def up
    s = Settings.new
    s.name = "status"
    s.value = "choosing"
    s.save
  end

  def down
    Settings.delete_all
  end
end
