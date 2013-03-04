class CreateDummyModel2 < ActiveRecord::Migration
	def change
		create_table :dummy_model_twos do |t|
      t.string :attr_1
			t.timestamps
		end
	end
end
