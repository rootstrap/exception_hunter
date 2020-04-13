class RenameErrorsOcurredAt < ActiveRecord::Migration[6.0]
  def change
    rename_column :exception_hunter_errors, :ocurred_at, :occurred_at
  end
end
