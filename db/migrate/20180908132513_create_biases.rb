class CreateBiases < ActiveRecord::Migration[5.2]
  def change
    create_table :biases do |t|
      t.float :libertarian
      t.float :green
      t.float :liberal
      t.float :conservative
      t.references :biasable, polymorphic: true

      t.timestamps
    end
  end
end
