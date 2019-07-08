class Plan < ApplicationRecord
  STRIPE_PLAN_ID_MONTHLY = "plan_monthly"

  has_many :subscriptions

  validates :stripe_plan_id, presence: true
  validates :name, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :currency, presence: true
  validates :interval, presence: true
  validates :interval_count, presence: true, numericality: { greater_than: 0 }

  after_create :create_stripe_plan
  after_destroy :delete_stripe_plan

  def self.monthly
    Plan.find_by(stripe_plan_id: STRIPE_PLAN_ID_MONTHLY)
  end

  def period_days
    case interval
    when "month"
      30
    when "year"
      365
    else
      0
    end
  end

  private

    def create_stripe_plan
      return if stripe_plan_exist?

      Stripe::Plan.create(
        amount: amount,
        interval: interval,
        interval_count: interval_count,
        product: {
          name: name
        },
        currency: currency,
        id: stripe_plan_id
      )
    end

    def delete_stripe_plan
      return unless stripe_plan_exist?

      Stripe::Plan.delete(stripe_plan_id)
    end

    def stripe_plan_exist?
      Stripe::Plan.retrieve(stripe_plan_id)
      true
    rescue Stripe::InvalidRequestError
      false
    end
end
