class CreateDatasets < ActiveRecord::Migration[5.2]
  def change
    create_table :datasets do |t|
      t.string :name
      t.string :srcName
      t.string :srcAddress
      t.string :desc
      t.string :datatype
      t.string :normalizer
      t.string :notes

      t.timestamps
    end
  end
end
