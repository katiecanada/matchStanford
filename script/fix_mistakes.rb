anne = User.where(:username => "ambarber")[0]
anne.firstname="Anne"
anne.middlename="Marie"
anne.save

kim = User.where(:username=>"kimhuynh")[0]
kim.middlename=""
kim.save


darren = User.where(:username=>"djindal")[0]
darren.middlename=""
darren.save

ebe = User.where(:username=>"eholve")[0]
ebe.middlename="ebe"
ebe.save

