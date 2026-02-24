# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

DAE Digital Fleet is a mobile-first web application prototype for fleet fuel management in Malaysia (specifically Kuching, Sarawak). It simulates a complete fuel transaction workflow including NFC verification, QR code generation, and electronic receipts.

**Live URL:** https://digitalfleet.daeit.com.sg (hosted via GitHub Pages)

## Technology Stack

- **Single-file application**: All HTML, CSS, and JavaScript in `index.html`
- **No build process**: Static files served directly
- **External dependencies** (loaded via CDN):
  - Leaflet.js for maps
  - QRCode.js for QR generation
  - Font Awesome for icons
  - Google Fonts (Inter)

## Development

To develop locally, simply open `index.html` in a browser. No server required for basic functionality, though maps require internet access.

For live server testing:
```bash
npx serve .
# or
python3 -m http.server 8000
```

## Architecture

### Screen-based Navigation

The app uses a single-page architecture with multiple screen `<div>` elements. Only one screen is visible at a time (controlled by the `.active` class). Screen transitions use the `Motion.transition()` function.

Key screens (in flow order):
1. `screen-welcome` - Splash/entry
2. `screen-home` - Dashboard with map and fuel stats
3. `screen-nfc` - NFC tap instructions
4. `screen-loading` - Processing animation
5. `screen-qr` - Generated QR code for cashier
6. `screen-approval` - Transaction approved
7. `screen-receipt` - E-receipt display
8. `screen-history` - Transaction history
9. `screen-settings` - Driver/vehicle profile
10. `screen-inbox` - Messages/notifications

### State Management

Global state variables:
- `currentScreenId` - Active screen tracker
- `transactionHistory` - Array of past transactions
- `inboxMessages` - Array of notification messages
- `map` - Leaflet map instance

### CSS Organization

CSS variables are defined in `:root` for DAE branding:
- Color palette (`--dae-primary`, `--dae-teal`, etc.)
- Glassmorphism effects (`--glass-bg`, `--glass-blur`)
- Typography scale and spacing tokens
- Shadow and transition presets

### Map Integration

The map uses Leaflet with OpenStreetMap tiles centered on Kuching (coordinates: 1.5535, 110.3593). Fuel station markers are hardcoded with custom styled `divIcon` markers.

## Key Functions

- `navigateTo(screenId)` - Main navigation handler
- `startFueling()` → `nfcTapped()` → `generateQRCode()` → `qrScanned()` - Fueling flow
- `renderHistory(filter)` / `renderInbox()` - Dynamic list rendering
- `generateSampleHistory()` / `generateSampleInbox()` - Generates mock data on app start

## Design System

- Mobile-first responsive design (max-width: 430px container)
- iOS-inspired UI patterns (navigation, cards, list items)
- Glassmorphism card styling with backdrop blur
- Primary gradient: blue (#3B82F6) to teal (#06B6D4)

## Journey Documentation Files

Three UX journey HTML files have been built alongside `index.html`. See **`JOURNEY.md`** for full details, design decisions, CSS patterns, and asset references.

| File | Purpose | Live URL |
|------|---------|----------|
| `journey_driver.html` | Fleet driver vertical timeline (6 stages) | /journey_driver.html |
| `journey_cashier.html` | Cashier POS vertical timeline (5 stages) | /journey_cashier.html |
| `journey_combined.html` | **Main** — two-column combined flow with sync bars | /journey_combined.html |

**`journey_combined.html` is the primary deliverable.** Always read `JOURNEY.md` before editing any journey file.
