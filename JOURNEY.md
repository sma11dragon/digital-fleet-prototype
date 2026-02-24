# JOURNEY.md — DAE Fleet Card UX Journey Files

Knowledge base for the three journey HTML files in this project. Read this before editing any `journey_*.html` file.

---

## What Was Built

Three self-contained HTML files that visualise the end-to-end DAE Fleet Card workflow as a visual reference/documentation page — separate from the live mobile app prototype (`index.html`).

| File | Description | Approx. lines |
|------|-------------|---------------|
| `journey_driver.html` | Vertical 6-stage timeline, driver perspective only | ~280 |
| `journey_cashier.html` | Vertical 5-stage timeline, cashier perspective only | ~260 |
| `journey_combined.html` | **Primary file.** Two-column layout, driver + cashier side by side with amber sync bars | ~453 |

**Live URLs (GitHub Pages):**
- https://digitalfleet.daeit.com.sg/journey_combined.html ← main deliverable
- https://digitalfleet.daeit.com.sg/journey_driver.html
- https://digitalfleet.daeit.com.sg/journey_cashier.html

---

## journey_combined.html — Full Reference

### Layout

- Max-width: `1120px`, centred
- Two-column CSS grid: `grid-template-columns: 1fr 1fr; gap: 14px`
- LEFT column: Fleet Driver (Mobile App)
- RIGHT column: Cashier (Station POS and Sunmi EDC Terminal)
- Amber sync bars (`.sync`) are **direct children of `.grid`**, not inside `.row`, so they span full width naturally

### Row Map

| Row | Driver (left) | Cashier (right) |
|-----|--------------|-----------------|
| 1 | Step 1 — Onboarding & Fleet Card Provisioning | — Not yet in journey — |
| 2 | Step 2 — Tap Phone on Vehicle NFC Sticker | — Not yet in journey — |
| 3 | Step 3 — Fleet App Authentication / QR Generated | — Not yet in journey — |
| **SYNC 1** | Driver Presents QR Code · Cashier Scans via Sunmi EDC Terminal | |
| 4 | Step 4 — Show QR Code at C-Store Counter | Step 1 — Scan Driver QR via Sunmi EDC Terminal |
| **SYNC 2** | Fueling Authorised · Cashier Presets Fuel Type & Nozzle on Station POS · Driver Notified | |
| 5 | Step 5 — Approved — Walks Back to Pump | Step 2 — Confirm Details & Preset Fuel on Station POS |
| **SYNC 3** | Driver Fueling at Pump · Cashier Monitors Nozzle Hangup Status on Station POS | |
| 6 | Step 6 — Driver Fueling Vehicle at Pump | Step 3 — Monitor POS — Await Nozzle Hangup |
| **SYNC 4** | Driver Drives Off · Cashier Enters Final Amount on Sunmi → DAE CMS Auto-Generates E-Receipt | |
| 7 | Step 7 — E-Receipt & Transaction History | Step 4 — Enter Final Amount on Sunmi → CMS Back End |

### CSS Classes (journey_combined.html)

```css
/* Layout */
.grid          /* max-width:1120px wrapper */
.col-hdrs      /* two-column header row */
.col-hdr       /* individual column header chip */
.row           /* two-column content row — grid 1fr 1fr, align-items:stretch */

/* Cards */
.card          /* standard step card — height:100% */
.card.empty    /* dashed placeholder when role not yet active */
.card.no-screen /* card without a preview panel — height:auto */

/* Step content */
.sn            /* circular step number badge — blue gradient */
.sn.icon       /* emoji icon variant */
.bd            /* text body flex container */
.badge         /* small uppercase label chip */
.ttl           /* step title */
.dsc           /* step description text */

/* Preview panels */
.pv            /* preview container — flex-shrink:0; width:112px */
.pv-lbl        /* label above preview */
.phone         /* 112×132px scaled phone frame (legacy — no longer used for driver column) */

/* Driver illustrated icon cards (replaced iframes) */
.drv-card      /* 112×132px navy gradient card */
.drv-ring      /* 64×64px glowing circular ring inside drv-card */
.drv-lbl       /* small uppercase caption below ring */

/* Cashier device mockups */
.sunmi-mock    /* 112×132px Sunmi EDC terminal CSS mockup */
.sunmi-bar     /* blue gradient header bar with DAE EDC logo */
.sunmi-screen  /* content area of Sunmi mockup */
.sunmi-btns    /* red/green button row at bottom */
.s-btn-r       /* red cancel button */
.s-btn-g       /* green confirm button */
.pos-mock      /* 112×132px Station POS display CSS mockup */
.pos-logo      /* logo header area of POS mockup */
.pos-screen    /* data content area of POS mockup */

/* Sync bars */
.sync          /* full-width amber sync point bar */

/* Legend */
.legend        /* flex row of legend items */
.leg-item      /* single legend entry */
.leg-chip      /* coloured chip label */
.leg-grey      /* grey chip style */
.leg-amber     /* amber chip style */
```

### Brand Colours

| Token | Value | Usage |
|-------|-------|-------|
| Background | `#0D1B3E` | Page body |
| Primary blue | `#1E90FF` | Accents, borders, step numbers |
| Accent blue | `#5BAEFF` | Text accents, SVG icon strokes |
| Teal | `#00d4aa` | Success states, secondary SVG strokes |
| Amber | `#FFA500` | Sync bar text and border |
| Amber bg | `rgba(255,165,0,.07)` | Sync bar background fill |

### Local Assets Used

All assets are in the **root project folder** (same directory as the HTML files):

| File | Used in |
|------|---------|
| `logo-nobackground.svg` | Sunmi EDC header bar (DAE logo) |
| `petros.svg.png` | Station POS logo — both POS mockups (rows 5 & 6, cashier column) |
| `NFC Sticker.webp` | Previously used in row 2 driver preview — now replaced by SVG icon card |
| `side view truck.png` | Previously used in row 6 driver preview — now replaced by SVG icon card |

> **Note:** `petronas.png`, `petron.png`, `shell.png`, `caltex.png` exist in the folder but are **not used** in the journey files — only `petros.svg.png` is used for the cashier Station POS branding.

### Driver Column: Illustrated Icon Cards

All 7 driver preview slots use `.drv-card` with inline SVG icons. There are **no iframes** in the driver column. The `.phone` CSS class and `iframe` scaling rules remain in the stylesheet but are unused — safe to leave.

| Row | Label | SVG Icon Description |
|-----|-------|----------------------|
| 1 | App Registration & Card Provisioning | Phone with registration form + teal checkmark |
| 2 | Tap Phone on Vehicle NFC Sticker | Phone with radiating NFC arcs (dashed teal) |
| 3 | QR Code Generated on App | 3-corner QR finder pattern in blue/teal |
| 4 | Present QR at C-Store Counter | Person silhouette holding phone with mini QR |
| 5 | Pump Authorised — Walk to Forecourt | Star/shield shape with teal checkmark |
| 6 | Fueling Vehicle at Pump | Fuel nozzle handle with teardrop fill |
| 7 | E-Receipt Received & History Logged | Document icon with teal check-circle overlay |

### Cashier Column: Device Mockups

| Row | Mockup Type | Content |
|-----|-------------|---------|
| 4 | `.sunmi-mock` | SVG QR code pattern + blue scan line + "Scan Driver QR" label |
| 5 | `.pos-mock` | PETROS logo + pump/fuel preset data (RM 180.00, Nozzle 3 Ready) |
| 6 | `.pos-mock` | PETROS logo + fueling-in-progress data + progress bar |
| 7 | `.sunmi-mock` | Amount entry screen with MYR input display + number grid |

---

## journey_driver.html — Reference

- Vertical single-column timeline, `max-width: 900px`
- 6 stages: Onboarding, NFC Tap, QR Generated, C-Store (Sunmi placeholder), Approved, Receipt
- Uses iframes (`iframe-1` → `screen-signup-success`, etc.) scaled to 43% — **requires a local server to function** (same-origin iframe restriction)
- Sub-list CSS for QR fields: `.li-key` class for uppercase field labels
- Stage 4 (Sunmi) uses an SVG terminal icon placeholder — not a device mockup

---

## journey_cashier.html — Reference

- Vertical single-column timeline, CSS identical to `journey_driver.html`
- 5 stages: Scan QR, Verify on Sunmi, Fueling Authorised/POS Preset, Read Final Amount, Submit to CMS
- Stage 1 only: iframe pointing to `screen-qr` (driver's phone from cashier's perspective)
- Stages 2–5: SVG icon placeholders (not full device mockups like `journey_combined.html`)

---

## Deployment

- **Host:** GitHub Pages, repository: `github.com/sma11dragon/digital-fleet-prototype`
- **Branch:** `main` — Pages builds automatically on push
- **Custom domain:** `digitalfleet.daeit.com.sg` (CNAME configured in repo)
- **Push command:** `git push origin main` (requires GitHub PAT with Contents: Read & Write)
- Build time after push: ~1–2 minutes

To publish changes:
```bash
git add journey_combined.html   # (or whichever files changed)
git commit -m "your message"
git push origin main
```

---

## Design Decisions & History

- **No iframes in driver column:** Originally the driver column used scaled iframes pointing at `index.html` screens via `navigateTo()`. These were replaced with illustrated `.drv-card` SVG icon cards because the user did not want mobile app screenshots in the document view.
- **PETROS only for cashier column:** Only `petros.svg.png` is used for the Station POS brand logo. Petronas, Petron, Shell, Caltex logos exist in the folder but are intentionally excluded.
- **Cashier column header wording:** "Cashier (Station POS and Sunmi EDC Terminal)" — this reflects that the cashier uses two devices: the fixed Station POS computer and the handheld Sunmi EDC terminal.
- **Amber sync bars:** `#FFA500` — mark the four points where driver and cashier interact simultaneously.
- **Line count target:** `journey_combined.html` should stay under 500 lines. Current: ~453 lines.
- **No external CDN dependencies:** All journey files are fully self-contained — no Leaflet, QRCode.js, Font Awesome, or Google Fonts. Pure HTML/CSS/SVG.
