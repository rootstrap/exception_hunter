class CreateExceptionHunterErrorGroups < ActiveRecord::Migration[6.0]
  def change
    enable_extension :pg_trgm

    create_table :exception_hunter_error_groups do |t|
      t.string :error_class_name, null: false
      t.string :message
      t.boolean :resolved, default: false

      t.timestamps

      t.index :message, opclass: :gin_trgm_ops, using: :gin
    end
  end
end
