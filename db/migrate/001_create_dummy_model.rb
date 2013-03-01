class CreateDummyModel < ActiveRecord::Migration
	def change
		create_table :dummy_models do |t|
      t.string :attr_1
      t.string :attr_2
			t.timestamps
		end
	end
end
