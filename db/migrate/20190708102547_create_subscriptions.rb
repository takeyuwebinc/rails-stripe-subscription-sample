class CreateSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :plan, null: false, foreign_key: true
      t.datetime :active_until, null: false
      t.string :stripe_subscription_id, null: false

      t.timestamps
    end
  end
end
