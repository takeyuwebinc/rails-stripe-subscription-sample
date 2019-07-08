# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Plan.create!(stripe_plan_id: Plan::STRIPE_PLAN_ID_MONTHLY, name: "Monthly Plan", amount: 980, currency: "jpy", interval: "month", interval_count: 1)
Plan.create!(stripe_plan_id: "plan_yearly", name: "Yearly Plan", amount: 9800, currency: "jpy", interval: "year", interval_count: 1)
