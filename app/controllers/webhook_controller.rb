class WebhookController < ApplicationController
  skip_forgery_protection

  # https://stripe.com/docs/billing/webhooks
  # https://stripe.com/docs/billing/invoices/workflow
  def stripe
    event = Stripe::Event.retrieve(params["id"])
    stripe_invoice = event.data.object

    case event.type
    when "invoice.finalized"
      # 請求が確定してお客からの支払いを待っている状態になった
      # 請求内容を取得して登録しておく
      # ひとまず追跡用のIDだけ取得したが、金額などほかの項目もほしければよしなに
      # https://stripe.com/docs/api/invoices/object
      user = User.find_by(stripe_customer_id: stripe_invoice.customer)
      user.invoices.create!(stripe_invoice_id: stripe_invoice.id)
    when "invoice.payment_succeeded"
      # 請求書について支払いが完了した
      # サブスクリプションを更新
      subscription = Subscription.find_by(stripe_subscription_id: stripe_invoice.subscription)
      subscription.synchronize_with_stripe!
    when "invoice.payment_failed"
      # 支払いに失敗した
      invoice = Invoice.find_by(stripe_invoice_id: stripe_invoice.id)
      # TODO: ユーザーに通知。invoice.stripe_hosted_invoice_url からの支払いを求める
    when "invoice.marked_uncollectible"
      # 支払期限を過ぎた
      invoice = Invoice.find_by(stripe_invoice_id: stripe_invoice.id)
      # TODO: 管理者に通知。督促状を送るなり何なり
    end

    head :ok
  end

end
