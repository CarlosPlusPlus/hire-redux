# == Schema Information
#
# Table name: interviews
#
#  id              :integer          not null, primary key
#  start_time      :datetime
#  end_time        :datetime
#  relationship_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Interview < ActiveRecord::Base
  attr_accessible :end_time, :relationship_id, :start_time

  has_one :relationship

  has_one :company, :through => :relationship
  has_one :job, 		:through => :relationship
  has_one :user,    :through => :relationship

  has_many :records,	:through => :relationship

end
