# customer

The customer app (كزيوني): browse offers nearby, claim one and pick it up at the store.
See the repo [README](../../README.md) to run it.

```
lib/
  main.dart                 entry: bootstrap with the app's config and DI
  core/                     app-wide code
    app/                    the app widget (theme, router)
    routes/                 page paths, redirects, the router
    l10n/                   Arabic + English strings
    widgets/                app-wide widgets (the tabs)
  features/<feature>/
    domain/                 entities + repository interfaces (+ their providers)
    data/                   implementations (offers_api lives only here)
    presentation/           screens + view models
```
