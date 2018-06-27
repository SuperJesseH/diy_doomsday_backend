class CreateUserDatasets < ActiveRecord::Migration[5.2]
  def change
    create_table :user_datasets do |t|
      t.integer :user_id
      t.integer :dataset_id
      t.float :weight
      t.string :notes

      t.timestamps
    end
  end
end
