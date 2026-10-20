# business

The store app: owners post offers, staff redeem claims at the counter.
See the repo [README](../../README.md) to run it.

```
lib/
  main.dart                 bootstrap
  app/                      shell: router (auth redirects), dependencies (DI), language button
  features/<feature>/
    domain/                 entities + repository interfaces (+ their providers)
    data/                   implementations (offers_api lives only here)
    presentation/           screens + view models
  l10n/                     Arabic + English strings
```
