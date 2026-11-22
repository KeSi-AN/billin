# Cloud setup (one time, ~15 minutes)

Three parts: Supabase tables, a Google login client, and switching Google on in Supabase.
Do them in this order on a computer.

## 1. Create the tables in Supabase (2 min)

1. Open https://supabase.com/dashboard → project **bill-app**.
2. Left menu → **SQL Editor** → **New query**.
3. Open `supabase/migrations/0001_shops_and_devices.sql` from this repo, copy **all** of it, paste, press **Run**.
4. It should say *Success. No rows returned.* (Running it again is harmless.)

## 2. Make a Google login client (8 min)

1. Open https://console.cloud.google.com → top bar project picker → **New project** → name it `bill-app` → Create, and select it.
2. Search bar → **Google Auth Platform** (or *APIs & Services → OAuth consent screen*) → **Get started**:
   - App name: `Shop App` · User support email: your email → Next
   - Audience: **External** → Next
   - Contact email: your email → Next → agree → **Create**.
3. **Audience** page → **Test users** → **Add users** → add every Google account that will sign in (yours, staff). Save.
   *(While the app is "in testing" only these accounts can sign in. That is fine for your shop.)*
4. **Clients** → **Create client**:
   - Application type: **Web application** · Name: `Supabase`
   - **Authorized redirect URIs** → Add URI:
     `https://cflgissfxuxjhbhwepcr.supabase.co/auth/v1/callback`
   - **Create**. Copy the **Client ID** and **Client secret** (keep the secret private).

## 3. Switch Google on in Supabase (3 min)

1. Supabase → **Authentication** → **Sign In / Providers** (or *Providers*) → **Google** → enable.
2. Paste the **Client ID** and **Client secret** from step 2 → **Save**.
3. **Authentication** → **URL Configuration** → **Redirect URLs** → **Add URL**, add both:
   - `shopappdev://login-callback`
   - `shopapp://login-callback`
   Save.

Then tell Claude "cloud setup done". Don't send the client secret or the database password.

## 4. Turn on syncing between phones (1 min)

1. Supabase → **SQL Editor** → **New query**.
2. Open `supabase/migrations/0002_sync_rows.sql` from this repo, copy **all** of it, paste, press **Run**.
3. It should say *Success. No rows returned.* (Running it again is harmless.)

## Using it

Phone → Settings → **Account & sync** → **Sign in with Google** → pick your account →
**Create "Sadiya Fashion" in the cloud** (first phone) or **Use on this phone** (other phones).
From then on this phone numbers bills INV-A/…, the next phone INV-B/…, and so on.
