# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

DAE Digital Fleet is a mobile-first web application prototype for fleet fuel management in Malaysia (specifically Kuching, Sarawak). It simulates a complete fuel transaction workflow including NFC verification, QR code generation, and electronic receipts.

**Live deployments** (each customer variant has its own GitHub repo and domain):

| Customer | Repo | Live URL |
|----------|------|----------|
| PETROS | `github.com/sma11dragon/digital-fleet-prototype` | https://petros-digitalfleet.daeit.com.sg |
| XCEL | `github.com/sma11dragon/xcel-fleet-prototype` | https://xcel-digitalfleet.daeit.com.sg |
| RapidKL | `github.com/sma11dragon/rapidkl-fleet-prototype` | https://rapidkl-digitalfleet.daeit.com.sg |

## Technology Stack

- **Single-file application**: All HTML, CSS, and JavaScript in `index.html`
- **No build process**: Static files served directly
- **External dependencies** (loaded via CDN):
  - Leaflet.js for maps
  - QRCode.js for QR generation
  - Font Awesome for icons
  - Google Fonts (Inter)

## Development

Open `index.html` in a browser directly. Maps require internet access (OpenStreetMap tiles).

For live server (needed if testing iframes in `journey_driver.html` / `journey_cashier.html`):
```bash
npx serve .
# or
python3 -m http.server 8000
```

## Deployment

Pushing to the `main` branch triggers GitHub Pages automatically (~1–2 min build time).

```bash
# Quick deploy with message
./quick-deploy.sh "Your commit message"

# Or manually — stage only the files you changed
git add index.html journey_combined.html
git commit -m "your message"
git push origin main
```

> **Warning:** `quick-deploy.sh` runs `git add .` which stages **all** files including untracked ones (e.g. `sunmi-screens/`, `.docx` files). Prefer manual staging when there are untracked files you don't intend to commit.

## Architecture

### Screen-based Navigation

Single-page app with multiple screen `<div>` elements; only one visible at a time via the `.active` class. Transitions use `Motion.transition()`.

Key screens (in flow order):
1. `screen-welcome` — Splash/entry
2. `screen-home` — Dashboard with map and fuel stats
3. `screen-nfc` — NFC tap instructions
4. `screen-loading` — Processing animation
5. `screen-qr` — Generated QR code for cashier
6. `screen-approval` — Transaction approved
7. `screen-receipt` — E-receipt display
8. `screen-history` — Transaction history
9. `screen-settings` — Driver/vehicle profile
10. `screen-inbox` — Messages/notifications

### Key Functions

- `navigateTo(screenId)` — Main navigation handler
- `startFueling()` → `nfcTapped()` → `generateQRCode()` → `qrScanned()` — Fueling flow
- `renderHistory(filter)` / `renderInbox()` — Dynamic list rendering
- `generateSampleHistory()` / `generateSampleInbox()` — Generates mock data on app start

### State Management

Global state variables: `currentScreenId`, `transactionHistory`, `inboxMessages`, `map` (Leaflet instance).

### CSS Organization

CSS variables in `:root` for DAE branding: color palette (`--dae-primary`, `--dae-teal`), glassmorphism (`--glass-bg`, `--glass-blur`), typography scale, spacing tokens, shadows, and transitions.

### Map Integration

Leaflet + OpenStreetMap, centred on Kuching (`1.5535, 110.3593`). Fuel station markers are hardcoded `divIcon` elements.

## Design System

- Mobile-first, `max-width: 430px` container
- iOS-inspired UI (navigation, cards, list items)
- Glassmorphism card styling with backdrop blur
- Primary gradient: blue `#3B82F6` → teal `#06B6D4`

## Files in This Repo

| File | Purpose |
|------|---------|
| `index.html` | Main mobile app prototype (PETROS / Kuching) |
| `index copy.html` | Local backup of `index.html` — **not deployed, not for editing** |
| `xcel_index.html` | XCEL customer variant — base file for customer-specific forks |
| `rapidkl_index.html` | RapidKL customer variant — bus fleet, Caltex stations, Cheras Selatan map, QR-less flow. Deployed as `index.html` in `github.com/sma11dragon/rapidkl-fleet-prototype` |
| `journey_combined.html` | **POC stage** deliverable — two-column driver + cashier flow |
| `journey_post_poc.html` | **Post-POC stage** deliverable — API-integrated, cashier-free flow |
| `journey_driver.html` | Driver-only vertical timeline (uses iframes — requires local server) |
| `journey_cashier.html` | Cashier-only vertical timeline |
| `sequence_happy_path.mmd` | Mermaid sequence diagram of the happy-path transaction flow |
| `quick-deploy.sh` | One-command deploy script (stages all files — see warning above) |
| `CNAME` | Custom domain for GitHub Pages (`petros-digitalfleet.daeit.com.sg`) |

### Local Assets (root folder)

- `logo-nobackground.svg` — DAE logo (used in Sunmi EDC header in journey files)
- `petros.svg.png` — Station POS brand logo (PETROS, used in cashier column)
- `sunmi-screens/` — Reference screenshots of Sunmi POS hardware (untracked, not deployed)
- `NFC Sticker.webp`, `side view truck.png` — Legacy assets, replaced by inline SVG in current journey files
- `petronas.png`, `petron.png`, `shell.png`, `caltex.png` — Present but **not used** in any journey file

## Journey Documentation Files

**Always read `JOURNEY.md` before editing any `journey_*.html` file.** It contains the full row map, CSS class reference, design decisions, and asset usage for each file.

> **Note:** The deployment URLs inside `JOURNEY.md` still reference the old domain (`digitalfleet.daeit.com.sg`). The correct live domain is `petros-digitalfleet.daeit.com.sg`.

| File | Purpose |
|------|---------|
| `journey_combined.html` | POC stage — two-column with amber sync bars |
| `journey_post_poc.html` | Post-POC stage — Meta/DAE co-branded, streamlined driver flow |

Key constraint: journey files have **no external CDN dependencies** — pure HTML/CSS/SVG only. Keep `journey_combined.html` under 500 lines.
