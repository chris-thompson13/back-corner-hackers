# CLI Commands for Database Management

#### Create a migration file
`rake db:create_migration NAME=<migration name>`

Examples:
`rake db:create_migration NAME=create_users_table`
`rake db:create_migration NAME=add_email_to_users`
`rake db:create_migration NAME=remove_email_from_users`

This will create a migration file in `db/migrate`. The code looks like this:

```ruby
class Users < ActiveRecord::Migration[5.1]
  def change
    # migration code here
  end
end
```

Put your migration code within the `change` method definition

Examples:

```ruby
class Users < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :f_name
      t.string :l_name
    end
  end
end
```

```ruby
class Users < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :age, :integer
  end
end
```

```ruby
class Users < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :age
  end
end
```

#### Execute migration files

`rake db:migrate`

Creates a `.sqlite3` file (e.g. `development.sqlite3`)
Creates a `schema.rb` file inside of `/db`

#### Undo last migration

`rake db:rollback`

Removes `schema.rb`

#### Drop a database

`rake db:drop`

Removes `.sqlite3` file from your project
*NOTE: does not remove `schema.rb`*
