#
# Clears the Users database and populates it
# from the "suids.txt" file. Run by opening
#   $ rails console
# and executing load("./script/last_chance_load.rb").
# Expects the format:
#   suid,firstname,middlename,lastname
#

User.destroy_all

f = File.open("suids.txt", 'r')

f.each_line do |line|
  d = line.strip.split(',')
  u = User.new

  u.username = d[0]
  u.firstname = d[1]
  u.middlename = d[2]
  u.lastname = d[3]
  u.email = u.username + "@stanford.edu"

  u.save

  p u
end