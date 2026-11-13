# Shop App (working name)

Offline-first billing and inventory for small Indian shops. It runs entirely on an Android phone, with an optional Bluetooth barcode scanner and thermal printer.
The phased plan is in [`docs/BUILD_PLAN.md`](docs/BUILD_PLAN.md). **This is build 0.5 (Phase 5: reports, dashboard, backup & restore).**

## What build 0.5 does

- **Shop setup** on first launch: name, logo, mobile, address, state, and GSTIN with checksum validation (a valid GSTIN fills in the state).
- **Items**: add, edit, delete and search, with barcode (typed, Bluetooth scanner or camera), price, MRP, unit, GST rate, tax-inclusive/exclusive pricing and HSN.
- **Billing**:
  - A **Bluetooth barcode scanner** works with no setup: it types into the always-focused search box. Scanning an item again bumps its quantity; an unknown barcode offers "Create item".
  - Name search, quick (unsaved) items, quantity stepper, and per-line price/quantity/discount.
  - Checkout with bill discount, Cash/UPI/Card/Credit (credit needs a customer name), change due, and the customer's name and phone.
- **GST math** in exact paise: inclusive/exclusive prices, line and bill discounts, CGST/SGST by rate, round-off. Invoice numbers restart each financial year (`INV/26-27/0001`).
- **Saved bills**: view, cancel (the number stays used), **print** and **share PDF**.
- **Printing**: ESC/POS receipts on 58/80 mm Bluetooth thermal printers (classic SPP), with a UPI pay QR. Printer setup screen with test print.
- **PDF**: A4 tax invoice (or bill of supply if not GST registered), with GST summary, amount in words and UPI QR, shared via the phone's share sheet (WhatsApp etc.).
- **Sales**: bills by day with totals per payment mode; Home shows today's sales.
- **Inventory** (build 0.2):
  - Per-item stock tracking with opening stock and a low-stock level. Every change goes in an append-only ledger (stock in, sale, cancel, adjust) with running balances.
  - Sales take stock out and cancelled bills put it back. Batches with expiry dates sell first-expiry-first-out.
  - A second selling unit (box of 12 → 12 pcs).
  - Categories and subcategories, item photos, list filters (low/out of stock, category) and sorting.
  - Stock alerts screen (low stock, expiring in 30 days, expired) and a Home tile counting what needs attention. A low-stock notification fires when a sale crosses the level.
  - **Excel/CSV import** with a preview and per-row error report (updates by barcode, then name), **export** to .xlsx, and a template.
  - **Barcode labels** on the receipt printer, plus in-store barcodes for loose items.
- **Settings**: invoice prefix, round-off, UPI ID, bill footer, printer.
- Everything is stored in a local SQLite database; no internet is needed.

- **Customers & dues (khata)** (build 0.3):
  - Credit sales need a customer (picked or added at checkout) and can take a part payment there. The rest goes into an append-only ledger with running balances; cancelling a bill reverses its entries.
  - Customers list with total due, a "with dues" filter and search. The customer page shows the balance and full khata.
  - Receive full or part payments (cash/UPI/card). Opening dues, and picking a contact via Android's picker (no contacts permission).
  - WhatsApp reminder with the due and a UPI pay link. Account statement PDF.

- **Purchases, expenses, profit & GST** (build 0.4):
  - **Suppliers** with their own list and ledger ("you owe"), kept apart from customers.
  - **Purchases**: enter a supplier's bill with item, quantity, cost, GST, and batch/expiry. Stock comes in and the item's cost price updates. Pay now or on credit (part payment allowed). Cancelling reverses stock and dues.
  - **Expenses** by month with quick categories.
  - **Profit** per bill (shown only on screen, never printed) and per month: gross profit minus expenses.
  - **Full GST**: HSN on lines, IGST instead of CGST+SGST when the customer's state (from their GSTIN) differs from the shop's, B2B invoices with the buyer's GSTIN and place of supply.
  - **Returns**: return some or all of a bill's items to issue a credit note (`CN/26-27/0001`). Stock goes back, and the refund is cash/UPI/card or comes off the customer's dues.
  - **Reports**: a month summary (sales, returns, purchases, expenses, profit, GST payable or credit carried forward) with warnings such as missing HSN. **Export GST report** creates an Excel workbook for the CA, shared via the share sheet. Sheets: Summary, B2B, B2CL, B2CS, CDNR, HSN (B2B/B2C), Docs and Purchases (for ITC).

- **Reports, dashboard, backup** (build 0.5):
  - **Home dashboard**: today's sales split into cash, UPI, card and credit (money paid at the counter on a credit bill counts as cash), dues and low stock on the tiles, and the top 5 items of the last 7 days.
  - **Reports** with a period filter (today, yesterday, this week, this or last month, financial year, or custom dates): sales (by day and by payment mode), purchases (by bill and by supplier), profit & loss, stock value (at cost and at sale price), item-wise, customer-wise, and a **day book** of every sale, receipt, return, purchase, supplier payment and expense with money in and out. Every report can be shared as **PDF** or **Excel**.
  - **Backup & restore** (Settings): one file holds everything, including photos. Share it to Google Drive or WhatsApp. Restoring on a new or reset phone replaces all data after a confirmation, upgrades older backups and relinks photos. Home reminds you when there are bills and no backup in the last 7 days.

**Not yet verified on real hardware:** Bluetooth printing of receipts and labels (no printer tested yet). Shop logos aren't printed on thermal receipts yet; they do appear on the PDF.

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
