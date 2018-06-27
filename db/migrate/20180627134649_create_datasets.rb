class CreateDatasets < ActiveRecord::Migration[5.2]
  def change
    create_table :datasets do |t|
      t.string :src
      t.string :desc
      t.string :normalizer
      t.string :notes

      t.timestamps
    end
  end
end
