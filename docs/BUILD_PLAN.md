# Shop billing and inventory app: phased build plan

**Product:** a phone-only billing and inventory app for small Indian shops. It needs no special hardware: just an Android phone, an optional **Bluetooth barcode scanner** and an optional **Bluetooth thermal printer**.
**Positioning** (from the Tohands teardown, section 7): offline-first, no hardware lock-in, full history on the free tier, proper GST, batches and expiry, multiple languages.
**Working name:** *TBD*. Pick your own; don't use anything resembling "Tohands".

---

## Guiding decisions

| Decision | Choice | Why |
|---|---|---|
| Platform | **Android first**, built in **Flutter** | Most Indian shopkeepers use Android, and Flutter keeps iOS open later. The teardown showed this stack works for this exact problem. |
| Data | **Offline-first**: the local SQLite database (via **Drift**) is the source of truth | Every screen works with no internet. Sync is added later, not built into the foundations. |
| State and architecture | `flutter_bloc`, a feature-first `data / domain / presentation` structure, `freezed` models, `go_router` | Proven and testable, and it scales to 30+ features |
| Money | Store amounts as **integer paise**, never floating-point numbers | Avoids rounding errors in totals and GST |
| Barcode scanner | Treat it as a **Bluetooth keyboard (HID mode)** | Almost every cheap Bluetooth scanner types the code like a keyboard, then presses Enter. No pairing code is needed: just a focused, hidden input on billing and stock screens. Camera scanning (`mobile_scanner`) is the fallback. |
| Printer | **ESC/POS** over **Bluetooth Classic (SPP)**, with BLE as a secondary option | ⚠️ Most cheap 58mm/80mm Indian thermal printers use *Classic* Bluetooth, which `flutter_blue_plus` (BLE-only) **can't** talk to. Use a Classic-capable plugin (e.g. `print_bluetooth_thermal`) behind your own `PrinterService` interface, so the transport can be swapped. |
| Sharing | PDF invoice + WhatsApp share through the **phone's share sheet / `wa.me` links** | Free, with no WhatsApp Business API cost. Automated sending can come later as a paid feature. |
| Backend | **None until Phase 6**, then Supabase (Postgres + auth + storage) with a sync layer | You can ship and test with real shops before paying for or running servers |

**Hardware to buy before Phase 1** (roughly ₹2.5–4k total): one 58mm Bluetooth thermal printer, one 80mm if your budget allows, and one Bluetooth barcode scanner. Prefer the common no-brand models shops actually buy. Test on real devices from day one.

---

## Phases and builds

Each phase ends in an **installable build** (APK through Play Console internal testing). Timings assume one developer working part-time to full-time; adjust to your pace.

### Phase 0: Foundation · build 0.0 · ~1 week
- Flutter project, flavors (dev/prod), lint rules, folder structure, CI (GitHub Actions to build the APK)
- Drift database with migrations set up from day one; repository interfaces
- App theme, typography, ₹/number/date formatting (Indian digit grouping: 1,00,000)
- Localization scaffold (`easy_localization` or `flutter_localizations`), English only for now
- Shop profile setup: name, address, phone, GSTIN (optional), logo
- **Exit:** the app installs, creates a shop profile and survives a restart with its data intact.

### Phase 1: Billing MVP · build 0.1 · ~3 weeks
*The thing a shop uses 100 times a day. Get this fast and right before anything else.*
- Item master (basic): name, price, barcode, unit, tax rate
- **Billing screen:** search items, quick "custom item + amount", quantity, line discount, bill discount, tax-inclusive or tax-exclusive pricing, round-off, payment mode (cash/UPI/card/credit)
- **Bluetooth scanner input:** scanning adds the item to the bill; an unknown barcode offers "create item"
- **Camera scan** fallback
- **Printing:** printer pairing/selection screen, test print, 58mm and 80mm receipt layouts, shop logo, UPI QR on the receipt, auto-reconnect, reprint
- **PDF invoice** + share to WhatsApp or anywhere
- Sales list (today / date range), view, cancel or return a bill
- Invoice numbering (per financial year, with a configurable prefix)
- **Exit:** a real shop can bill a 10-item scanned sale and print it in **under 20 seconds**, fully offline.

### Phase 2: Inventory · build 0.2 · ~3 weeks
- Stock tracking switch per item, stock in/out/adjust with a reason, stock history
- Low-stock threshold and alerts (local notifications)
- Categories and subcategories, item images, search/filter/sort
- **Multiple units** (e.g. 1 box = 12 pieces), with selling in either unit
- **Batches and expiry** (optional per item) with first-expiry-first-out on sale, plus near-expiry and expired lists
- **Barcode label printing** (price/name/barcode) on label printers or thermal paper
- **Excel/CSV import and export** of items, with a validation and error report
- **Exit:** a grocery or pharmacy shop can load 500+ items from Excel and see stock drop correctly as it bills.

### Phase 3: Customers and dues ("khata") · build 0.3 · ~2 weeks
- Customers ("parties") with phone, address and GSTIN; import from contacts
- Credit sales, part payments, settlements (full/partial), running balance
- Customer ledger + PDF statement
- **WhatsApp payment reminder** via a prefilled `wa.me` message with a UPI payment link (`upi://pay?...`)
- **Exit:** the dues total always matches the sum of the ledger entries, which is covered by unit tests.

### Phase 4: Purchases, expenses and full GST · build 0.4 · ~3 weeks
- Suppliers, purchase bills (stock in at cost price), supplier ledger and payments
- Expenses with categories
- Profit per item and per bill (selling price minus cost)
- **Full GST:** HSN/SAC codes, CGST+SGST vs IGST chosen by the customer's state, tax-inclusive pricing math, B2B invoices with buyer GSTIN, credit notes for returns
- GST report exports (GSTR-1-style sales register, HSN summary) as Excel
- **Exit:** a CA can file monthly returns from the exports without re-typing anything.

### Phase 5: Reports and dashboard · build 0.5 · ~2 weeks
- Home dashboard: today's sales, cash vs UPI, dues outstanding, low stock, top items
- Reports: sales, purchases, profit and loss, stock value, item-wise, customer-wise, day book; date filters; PDF and Excel export
- **Backup and restore:** local file + Google Drive backup (so data is safe before cloud sync exists)
- **Exit:** a closed beta with **5–10 real shops** runs for 2+ weeks without data loss.

### Phase 6: Accounts, cloud sync and staff · build 0.6 · ~4 weeks
- Phone OTP login (Supabase Auth or Firebase Auth)
- **Sync engine:** local Drift remains the source of truth. Changes queue up and push when online; pull with conflict rules (last-write-wins for master data, append-only for bills and stock movements). Consider PowerSync/ElectricSQL against building your own.
- Multiple devices per shop, **staff accounts with roles** (cashier can bill but can't edit prices or delete bills, etc.)
- Restore everything on a new phone
- **Exit:** two phones billing offline at the same time merge correctly once they're back online.

### Phase 7: Launch 1.0 · ~2 weeks
- Hindi + 2–3 regional languages (strings already externalized in Phase 0)
- Onboarding tour, sample data mode, help videos
- Crash reporting (Sentry/Crashlytics), privacy-friendly analytics
- Privacy policy, data deletion, Play Store listing and screenshots
- **Exit:** a public release on the Play Store.

### Phase 8: After launch (pick by demand)
- Paid plan (Razorpay/Play Billing): automatic WhatsApp bills and reminders (WhatsApp Business API), premium invoice templates, multi-shop
- E-invoice / e-way bill integration
- UPI payment confirmation (via a payment gateway's dynamic QR + webhook)
- AI helpers: item entry from a photo of a supplier bill, reorder suggestions
- iOS build, tablet/desktop counter mode

---

## Core data model (Drift tables, first version)

`shop` · `item` (name, sku, barcode, unit, alt_unit, conversion, mrp, sale_price, cost_price, tax_rate, hsn, track_stock, low_stock_qty) · `item_batch` (batch_no, expiry, qty) · `category` · `stock_movement` (item, batch, qty ±, type: sale/purchase/adjust/return, ref_id) · `party` (customer/supplier, phone, gstin, state) · `bill` + `bill_line` · `purchase` + `purchase_line` · `payment` (party, amount, mode, against_bill) · `expense` · `printer_profile` · *(Phase 6)* `user`, `staff_role`, `sync_queue`

Rules: stock is **always calculated from `stock_movement`** (with a cached total), never edited directly. Bills are never deleted, only cancelled. All amounts are in paise.

## Risks to check early

1. **Printer compatibility.** Test 3–4 popular cheap printer models in Phase 1; some need different character sets or image-printing modes for logos and QR codes.
2. **Scanner keyboard behaviour.** Some scanners send odd suffixes or keyboard layouts. Make the suffix/prefix configurable.
3. **GST correctness.** Get a CA to review the tax calculations and exports before Phase 4 ships.
4. **Sync is the hardest part.** It's kept to Phase 6 deliberately, so a rewrite never touches billing.
