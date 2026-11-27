# What the website can read from the bill app's cloud

The bill app keeps every shared record in the Supabase table `sync_rows`
(see `supabase/migrations/0002_sync_rows.sql`): one row per record with
`tbl`, `row_id` (the record's id, shared by all phones) and `data` (its
columns as JSON). Records are never deleted; hidden ones have
`is_active = 0`.

General rules:

- Booleans are integers `0` / `1`.
- Dates are integers: Unix seconds.
- A link to another record holds that record's `row_id` (a text uid).
- Keys are only ever added, never renamed or removed. Items saved before
  a key existed don't have it: treat a missing key as `null` (or `0`).

## `tbl = 'items'` (products)

Existing keys include `name`, `sale_price_paise`, `mrp_paise`,
`is_active`, `track_stock`, `low_stock_milli`, `category_id`.

Added in database v10 / v11:

| key | type | meaning |
|---|---|---|
| `colours` | JSON **string** or null | `"[{\"name\":\"Plum\",\"hex\":\"#6b3f6e\"},{\"name\":\"Multicolour\"}]"`; `hex` optional, lowercase `#rrggbb` |
| `fabric` | string or null | e.g. "Rayon" |
| `care` | string or null | e.g. "Dry wash only" |
| `description` | string or null | |
| `pattern` | string or null | print / pattern, free text, e.g. "Floral block print, half sleeves" (v11) |
| `show_on_website` | 0 / 1 | listed on the website |

Photos aren't synced yet (`image_path` stays on the phone).

## `tbl = 'item_sizes'` (versions: colour and/or size)

Each row is one version of a product: a colour, a size, or both.

| key | type | meaning |
|---|---|---|
| `item_id` | uid string | the product's `row_id` |
| `colour` | string or null | null for a size-only version (v11) |
| `colour_hex` | string or null | lowercase `#rrggbb` (v11) |
| `size` | string | `''` for a colour-only version |
| `position` | int | display order, ascending |
| `sale_price_paise` | int or null | null: the product's `sale_price_paise` |
| `barcode` | string or null | |
| `is_active` | 0 / 1 | 0: removed, hide it |
| `created_at` | int | Unix seconds |

A version always has a colour, a non-empty size, or both. Its stock is
not stored here (see below). A product with no active versions is
"free size".

## Stock

`tbl = 'stock_movements'` rows are only ever added. Keys include
`item_id`, `size_id` (the version's `row_id`, or null), `quantity_milli`.

- A version's stock = SUM(`quantity_milli`) where `size_id` is its
  `row_id`, divided by 1000 for pieces.
- A product's total stock = SUM(`quantity_milli`) over its `item_id`.

The format is checked by the test "sizes, their stock and the website
details reach the other phone" in `test/features/cloud/sync_engine_test.dart`.
