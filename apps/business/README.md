# business

The store app: owners post offers, staff redeem claims at the counter.
See the repo [README](../../README.md) to run it.

```
lib/
  main.dart                 entry: bootstrap with the app's config and DI
  core/                     app-wide code
    app/                    the app widget (theme, router)
    providers/              DI: which repositories the app uses
    routes/                 page paths, auth redirects, the router
    l10n/                   Arabic + English strings
    widgets/                app-wide widgets (language button)
  features/<feature>/
    domain/                 entities + repository interfaces (+ their providers)
    data/                   implementations (offers_api lives only here)
    presentation/           screens + view models
```
