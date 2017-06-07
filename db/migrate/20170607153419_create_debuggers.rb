class CreateDebuggers < ActiveRecord::Migration[5.0]
  def change
    create_table :debuggers do |t|
      t.string  :method,      null: true
      t.string  :method_type, null: true
      t.integer :user_id,     null: true
      t.integer :document_id, null: true
      t.integer :datum_id,    null: true
      t.text    :notes,       null: true
      t.timestamps
    end
  end
end
