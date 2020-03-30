class CreateExceptionHunterErrors < ActiveRecord::Migration[6.0]
  def change
    create_table :exception_hunter_errors do |t|
      t.string :class_name, null: false
      t.string :message
      t.timestamp :ocurred_at, null: false
      t.json :environment_data
      t.json :custom_data
      t.string :backtrace, array: true, default: []

      t.timestamps
    end
  end
end
