class Task
  include MotionModel::Model

  columns :name => :string,
          :details => :string,
          :created_at => :string,
          :updated_at => :string

  belongs_to :user
end
