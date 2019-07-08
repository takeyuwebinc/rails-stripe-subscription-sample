class CreatePlans < ActiveRecord::Migration[6.0]
  def change
    create_table :plans do |t|
      t.string :stripe_plan_id, null: false
      t.string :name, null: false
      t.integer :amount, null: false
      t.string :currency, null: false
      t.string :interval, null: false
      t.integer :interval_count, null: false

      t.timestamps
    end
  end
end
