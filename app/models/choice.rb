class Choice < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :from_user, :foreign_key => "from_id", :class_name => "User"
  belongs_to :to_user, :foreign_key => "to_id", :class_name => "User"
end
