class CreateUsersTable < ActiveRecord::Migration[5.1]
  def change
    t.string :username
    t.string :password
    t.string :fname
    t.string :lname
  end
end
