class AddTimestampsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_timestamps(:users)
  end
end
