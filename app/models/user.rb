class User < ApplicationRecord
  has_one :subscription, dependent: :destroy
  has_one :plan, through: :subscription
  has_many :invoices, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true

  before_create :create_stripe_customer
  after_create :create_initial_subscription
  after_update :update_stripe_customer
  after_destroy :delete_stripe_customer

  def active?
    subscription.active?
  end

  private

    def create_stripe_customer
      stripe_customer = Stripe::Customer.create(name: name, email: email, preferred_locales: ["ja"])
      self.stripe_customer_id = stripe_customer.id
    end

    def update_stripe_customer
      Stripe::Customer.update(stripe_customer_id, name: name, email: email)
    end

    def delete_stripe_customer
      Stripe::Customer.delete(stripe_customer_id)
    end

    def create_initial_subscription
      create_subscription!
    end
end
