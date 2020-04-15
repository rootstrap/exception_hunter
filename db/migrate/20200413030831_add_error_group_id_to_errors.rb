class AddErrorGroupIdToErrors < ActiveRecord::Migration[6.0]
  def change
    add_reference :exception_hunter_errors, :error_group,
                  index: true,
                  foreign_key: { to_table: :exception_hunter_error_groups }
  end
end
