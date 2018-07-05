class CreateUserDatasets < ActiveRecord::Migration[5.2]
  def change
    create_table :user_datasets do |t|
      t.integer :user_id
      t.integer :dataset_id
      t.boolean :positive_corral, default: true
      t.float :weight
      t.string :notes

      t.timestamps
    end
  end
end
