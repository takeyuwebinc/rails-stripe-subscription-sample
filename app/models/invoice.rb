class Invoice < ApplicationRecord
  belongs_to :user

  validates :stripe_invoice_id, presence: true

  def stripe_hosted_invoice_url
    stripe_object.hosted_invoice_url
  end

  private

    def stripe_object
      Stripe::Invoice.retrieve(stripe_invoice_id)
    end
end
