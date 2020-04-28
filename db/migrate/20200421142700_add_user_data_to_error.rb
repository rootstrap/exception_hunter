class AddUserDataToError < ActiveRecord::Migration[6.0]
  def change
    add_column :exception_hunter_errors, :user_data, :json
  end
end
