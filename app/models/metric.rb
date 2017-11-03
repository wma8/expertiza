class Metric < ActiveRecord::Base
  enum source: [ :github ]
  has_one :team
  has_one :assignment
  has_many :metric_data_point, dependent: :destroy
end
