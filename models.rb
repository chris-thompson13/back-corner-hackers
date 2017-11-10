# Models

# ActiveRecord classes go here. These are object-model
# representations of your database tables. All classes defined
# here must inherit from ActiveRecord::Base

# e.g.
class User < ActiveRecord::Base
  has_many :messages, dependent: :destroy
end

class Message < ActiveRecord::Base
  belongs_to :user
end
