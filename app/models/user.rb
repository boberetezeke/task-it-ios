class User
  include MotionModel::Model

  columns :name => :string,
          :created_at => :string,
          :updated_at => :string

  has_many :tasks
end
