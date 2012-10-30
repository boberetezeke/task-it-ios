class User
  include MotionModel::Model

  columns :name => :string

  has_many :tasks
end
