# Shop App (working name)

Offline-first billing and inventory for small Indian shops. It runs entirely on an Android phone, with an optional Bluetooth barcode scanner and thermal printer.
The phased plan is in [`docs/BUILD_PLAN.md`](docs/BUILD_PLAN.md). **This is build 0.0 (Phase 0: foundation).**

## What build 0.0 does

- First-launch **shop setup**: name, logo (gallery or camera), mobile, address, city, PIN code, state, and GSTIN with checksum validation. A valid GSTIN fills in the state automatically.
- **Home** shows the shop card and placeholders for New bill, Items, Customers and Reports, which arrive in later builds.
- Editing the shop profile from Home.
- Everything is stored in a local SQLite database; no internet is needed.

## Project layout

```
lib/
  main.dart                  wires the database + repositories, runs the app
  app/                       root widget, router (first-launch redirect), flavors
  core/
    db/                      Drift database + tables (offline source of truth)
    money/                   Money = integer paise, Indian ₹1,00,000.00 formatting
    india/                   GSTIN checksum, GST state codes, phone/PIN validation
    format/                  date formatting (en_IN)
    theme/                   Material 3 theme tuned for a shop counter
  features/<feature>/
    domain/                  entities (freezed), repository interfaces, validators
    data/                    repository implementations (Drift)
    presentation/            cubits, pages, widgets
  l10n/app_en.arb            every UI string (gen code in l10n/gen/)
drift_schemas/               schema snapshots, one per DB version (never edit old ones)
test/                        unit, cubit, repository (in-memory SQLite) and widget tests
```

## Day-to-day commands

Requires Flutter 3.50 (stable) with `flutter/bin` on your PATH.

```bash
flutter pub get
dart run build_runner build      # after changing freezed models or Drift tables
flutter gen-l10n                 # after changing lib/l10n/app_en.arb
flutter analyze
flutter test
flutter run --flavor dev         # dev build: "Shop App Dev", installs next to prod
flutter build apk --flavor dev --release
```

### Changing the database

1. Edit the tables in `lib/core/db/tables.dart` and bump `schemaVersion` in `app_database.dart`.
2. Add the migration step in `AppDatabase.migration`.
3. Run `dart run drift_dev make-migrations`. This snapshots the new schema and generates migration tests in `test/drift/`.

## Rules that keep the app correct

- **Money is always `Money` (paise as an `int`)**, never a `double`.
- **The local database is the source of truth.** Screens read through repositories, and repositories read Drift.
- **No hard-coded UI text**: every string goes in `app_en.arb`, so Hindi and regional languages are a translation job, not a refactor.
- Generated files (`*.g.dart`, `*.freezed.dart`, `l10n/gen`) are committed; CI fails if they're out of date.

## Before the Play Store

- Choose the real app name and application ID (currently `com.shopapp.shop_app`) and update `android/app/build.gradle.kts`, the `app_name` values there, and `appTitle` in the ARB.
- Create an upload keystore and a release signing config (release builds currently use the debug key).
