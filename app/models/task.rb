class Task
  include MotionModel::Model

  columns :name => :string,
          :details => :string

  belongs_to :user
end
