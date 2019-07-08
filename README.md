# README

## Development

### Stripe 設定

#### API キー

https://dashboard.stripe.com/test/apikeys

シークレットキー を `RAILS_ROOT/.env` に記載する。

```bash
$ cp .env.sample .env
$ vi .env
$ cat .env
STRIPE_SECRET_KEY=sk_test_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

### Rails Server

```bash
$ docker-compose up
# (snip)
app_1  | => Booting Puma
app_1  | => Rails 6.0.0.rc1 application starting in development
app_1  | => Run `rails server --help` for more startup options
app_1  | Puma starting in single mode...
app_1  | * Version 3.12.1 (ruby 2.6.3-p62), codename: Llamas in Pajamas
app_1  | * Min threads: 5, max threads: 5
app_1  | * Environment: development
app_1  | * Listening on tcp://0.0.0.0:3000
app_1  | Use Ctrl-C to stop
```

```bash
$ docker-compose exec app bundle exec rails db:setup
```

### Ngrok

```bash
$ docker-compose exec app bundle exec ngrok http 3000
```

### Stripe Webhook

https://dashboard.stripe.com/test/webhooks で Webhook を設定

- URL: `https://xxxxxxxx.ngrok.io/webhook/stripe`
- イベントタイプ:
  - `invoice.marked_uncollectible`
  - `invoice.finalized`
  - `invoice.payment_succeeded`

### Open

https://xxxxxxxx.ngrok.io
