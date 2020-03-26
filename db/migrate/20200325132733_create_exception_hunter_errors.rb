class CreateExceptionHunterErrors < ActiveRecord::Migration[6.0]
  def change
    create_table :exception_hunter_errors do |t|
      t.string :name, null: false, unique: true
      t.text :message
      t.timestamp :ocurred_at, null: false
      t.json :environment_data
      t.json :custom_data
      t.text :backtrace

      t.timestamps
    end
  end
end
