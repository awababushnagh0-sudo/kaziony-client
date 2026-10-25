# admin

Offers admin dashboard (Flutter Web). See the [repo README](../../README.md) to run it.

```
lib/
  main.dart                 entry: bootstrap with the app's config and DI
  core/                     app-wide code
    app/                    the app widget (theme, dashboard style, router)
    providers/              DI: which repositories the app uses
    routes/                 page paths, sign-in redirects (?from=), the router
    list/                   shared list logic: ListQuery, ListController, PagedTable
    utils/                  Arabic / English switch
    l10n/                   Arabic + English strings
    widgets/                app-wide widgets: side-menu shell, coming-soon page
  features/<feature>/
    domain/                 entities + repository interfaces (+ their providers)
    data/                   implementations (offers_api lives only here)
    presentation/           screens, dialogs, view models
```
