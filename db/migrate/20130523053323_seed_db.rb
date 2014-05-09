class SeedDb < ActiveRecord::Migration
  def up
    u = User.new
    u.firstName = "John"
    u.lastName = "Snow"
    u.username = "jsnow"
    u.save()

    u = User.new
    u.firstName = "Sansa"
    u.lastName = "Stark"
    u.username = "sstark"
    u.choices = "[3]"
    u.save()

    u = User.new
    u.firstName = "Geoffrey"
    u.lastName = "Barathian"
    u.username = "gbarathian"
    u.choices = "[4]"
    u.save()

    u = User.new
    u.firstName = "Marjorie"
    u.lastName = "Tyrell"
    u.username = "mtyrell"
    u.save()

    u = User.new
    u.firstName = "Anne"
    u.lastName = "Hathaway"
    u.username = "ahathaway"
    u.save()

    u = User.new
    u.firstName = "James"
    u.lastName = "Bond"
    u.username = "jbond"
    u.save()
  end

  def down
  end
end
