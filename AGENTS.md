# DAE Digital Fleet - Agents Guide

This guide helps agentic coding agents work effectively in this repository.

## Project Overview

**DAE Digital Fleet** is a mobile-first web application prototype for fleet fuel management in Malaysia (Kuching, Sarawak). Single-file architecture with HTML/CSS/JS in `index.html`.

- **Live URL**: https://digitalfleet.daeit.com.sg
- **Type**: Static prototype (no build process)
- **Main file**: `index.html` (4,000+ lines)

## Development Commands

### Local Development
```bash
# Quick test (open directly in browser)
open index.html

# With local server (recommended for maps)
npx serve .
python3 -m http.server 8000
```

### Deployment
```bash
# Full deploy with checks
cd "/Users/siewloongchan/Documents/DAE - Operations/Countries/Malaysia/Digital Fleet/digital-fleet-prototype"
./deploy-to-github.sh

# Quick deploy with message
./quick-deploy.sh "Your commit message"
```

### Git Commands
```bash
git status
git add .
git commit -m "Update: description"
git push origin main
```

### Backup & Restore
```bash
# Create timestamped backup (keeps last 10)
./create-backup.sh

# Restore from specific backup
./restore-backup.sh digital-fleet-backup_20260204_174631.tar.gz

# Sync backups to NAS
./sync-to-nas.sh

# List available backups
ls -la backups/
```

## Architecture

### Screen-Based Navigation
Single-page app with screen `<div>` elements. Only one screen visible at a time (`.active` class).

**Screen IDs (in flow order)**:
- `screen-welcome` - Splash entry
- `screen-onboarding-{1,2,3}` - App tour
- `screen-cta` - Final onboarding CTA
- `screen-home` - Dashboard with map
- `screen-nfc` - NFC tap simulation
- `screen-loading` - Processing animation
- `screen-qr` - Generated QR for cashier
- `screen-approval` - Transaction approved
- `screen-receipt` - E-receipt display
- `screen-history` - Transaction history
- `screen-settings` - Driver/vehicle profile
- `screen-inbox` - Messages/notifications

### Key Functions
- `navigateTo(screenId)` - Main navigation handler using `Motion.transition()`
- `startApp()` → `nfcTapped()` → `generateQRCode()` → `qrScanned()` - Fueling flow
- `renderHistory(filter)` / `renderInbox()` - Dynamic list rendering
- `initializeMap()` - Leaflet map setup (Kuching coordinates)

### State Management
```javascript
currentScreenId     // Active screen tracker
transactionHistory  // Array of past transactions
inboxMessages       // Array of notification messages
map                 // Leaflet map instance
transactionData     // Current transaction data
```

## Code Style Guidelines

### Naming Conventions
- **CSS classes**: kebab-case (`.history-item`, `.btn-primary`)
- **CSS IDs**: kebab-case (`#screen-home`, `#qrCodeDisplay`)
- **JavaScript variables**: camelCase (`transactionHistory`, `currentScreenId`)
- **Functions**: camelCase (`generateQRCode()`, `renderInbox()`)
- **Constants**: UPPER_SNAKE_CASE where applicable

### CSS Organization
```css
/* Use CSS variables from :root */
--dae-primary: #004B8E;      /* Brand blue */
--dae-success: #34C759;       /* Success green */
--dae-error: #FF3B30;        /* Error red */
--text-primary: #3C3C49;      /* Primary text */
--bg-secondary: #F5F5F7;      /* Background */
--card-bg: #FFFFFF;           /* Card background */
--card-border: rgba(0,0,0,0.08);
--shadow-card: 0 1px 3px rgba(0,0,0,0.08);
--space-md: 16px;            /* Spacing tokens */
--transition-fast: 150ms cubic-bezier(0.4, 0, 0.2, 1);
```

### JavaScript Patterns
- Use `const` and `let` (avoid `var`)
- Template literals for HTML strings
- Arrow functions for callbacks
- Try-catch blocks for map initialization
- `console.error()` for debugging (not `console.log`)

### HTML Structure
- Use semantic HTML5 elements
- Data attributes for dynamic content
- `onerror` handlers for images: `onerror="this.style.display='none'"`

## Design System (DAE × Jonathan Ive)

### Typography
- **Primary**: Inter (Google Fonts)
- **Secondary**: Plus Jakarta Sans
- Achieve hierarchy through size, weight, spacing—not decoration

### Color System
- Primary: `#004B8E` (DAE Blue)
- Text: `#3C3C49` (Dark Grey)
- Use color ONLY for primary actions and status states
- **Forbidden**: Gradients, glassmorphism, neumorphism, decorative colors

### UI Principles
1. Subtract until only necessary remains
2. Design should be self-evident
3. Visual calm enables speed and confidence
4. Interface should feel engineered, not decorated

## Error Handling

### JavaScript
```javascript
try {
    // Map initialization
} catch (error) {
    console.error('Map initialization error:', error);
}

// Validation with fallbacks
if (!transaction) return;
const vehicleModel = txn.vehicleModel || getVehicleModelByPlate(txn.vehicle);
```

### CSS
- Always provide fallback values
- Use `onerror` for images
- Handle missing map gracefully

## External Dependencies

Loaded via CDN in `<head>`:
- **Leaflet**: Maps (OpenStreetMap tiles)
- **QRCode.js**: QR generation
- **Font Awesome**: Icons
- **Google Fonts**: Inter font family

## Deployment Checklist

Before deploying:
1. Test locally with `npx serve .`
2. Verify all screens transition correctly
3. Check map loads and markers display
4. Ensure QR code generates properly
5. Run `./deploy-to-github.sh`

## UX Safety Guardrails

When making changes:
- ✅ Preserve navigation structure and screen count
- ✅ Preserve task flow order
- ✅ Preserve information visibility
- ✅ Preserve button placement and hierarchy
- ❌ Never add new features or gestures
- ❌ Never hide critical information
- ❌ Never increase cognitive load

## Testing

No automated test suite. Manual testing required:
1. Open `index.html` in browser
2. Test all screen transitions
3. Verify map displays in Kuching area
4. Test fueling flow end-to-end
5. Check responsive behavior (mobile/desktop)

## File Locations

```
/Users/siewloongchan/Documents/DAE - Operations/Countries/Malaysia/Digital Fleet/digital-fleet-prototype/
├── index.html              # Main application (single file)
├── index copy.html         # Backup copy
├── *.png, *.svg           # Image assets
├── deploy-to-github.sh     # Deployment script
├── quick-deploy.sh         # Quick deployment
├── create-backup.sh        # Backup creation
├── restore-backup.sh       # Restore from backup
├── sync-to-nas.sh          # NAS synchronization
├── backups/                # Backup archives (auto-generated)
├── BACKUP-INFRASTRUCTURE.md # Backup documentation
├── AGENTS.md              # Agent guidance
├── CLAUDE.md              # Project overview
├── SKILL.md               # UI redesign guidelines
├── DEPLOYMENT-SETUP-GUIDE.md  # Deployment docs
└── .gitignore             # Git ignore rules
```
