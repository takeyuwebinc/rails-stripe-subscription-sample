class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :plan

  before_validation :set_initial_plan
  before_create :create_stripe_subscription
  after_destroy :cancel_stripe_subscription

  def active?
    active_until >= Time.current
  end

  def synchronize_with_stripe!
    update!(active_until: Time.zone.at(stripe_object.current_period_end))
  end

  # 自動請求にする
  # 一度 Stripe でカード決済を成功させていれば、以降そのカードを使って自動決済できる
  def start_charge_automatically!
    Stripe::Subscription.update(stripe_subscription_id, collection_method: "charge_automatically", days_until_due: nil)
  end

  def charge_automatically?
    stripe_object.collection_method == "charge_automatically"
  end

  private

    def set_initial_plan
      self.plan ||= Plan.monthly
    end

    def create_stripe_subscription
      # 通常、Stripeではクレジットカードの登録（Token化）を先に済ませておかないと
      # 有料プランを直接設定できない（無料プランはできる）
      #
      # - 今回は最初にクレジットカードの登録をさせるのを避けたい かつ
      # - 無料トライアルは設けない
      # - 後払い（支払い待ちでも使える）
      #
      # を実現したかった。
      #
      # そのために必要なのは次の２つ
      #
      # - `collection_method: 'send_invoice'`
      #   - 請求書を送る
      # - `days_until_due: 14`
      #   - 支払期日を14日後にする
      #
      # 加えて、初回請求書をクレジットカードで支払った後は自動決済させたいので
      # 決済確認後 `Stripe::Subscription.update(stripe_subscription_id, collection_method: "charge_automatically", days_until_due: nil)` する
      stripe_subscription = Stripe::Subscription.create({
        customer: user.stripe_customer_id,
        items: [
          {
            plan: plan.stripe_plan_id,
          }
        ],
        collection_method: 'send_invoice',
        days_until_due: 14
      })
      self.stripe_subscription_id = stripe_subscription.id
      self.active_until = Time.zone.at(stripe_subscription.current_period_end)
    end

    def cancel_stripe_subscription
      Stripe::Subscription.delete(stripe_subscription_id)
    end

    def stripe_object
      Stripe::Subscription.retrieve(stripe_subscription_id)
    end
end
