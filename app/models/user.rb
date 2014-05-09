class User < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :to_choices, :foreign_key => "from_id", :class_name => "Choice"
  has_many :to_users, :through => :to_choices

  has_many :from_choices, :foreign_key => "to_id", :class_name => "Choice"
  has_many :from_users, :through => :from_choices
end
