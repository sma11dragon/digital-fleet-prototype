# DAE Digital Fleet - Backup Infrastructure Documentation

## 📋 Overview

This document describes the backup infrastructure for the DAE Digital Fleet prototype, ensuring the mobile UI/UX mockup (live at https://digitalfleet.daeit.com.sg) can be restored at any time.

## 🏗️ Current Infrastructure

### 1. Local PC (Primary Development)
- **Location**: `/Users/siewloongchan/Documents/DAE - Operations/Countries/Malaysia/Digital Fleet/digital-fleet-prototype/`
- **Purpose**: Primary development and testing environment
- **Files**: All source files (HTML, CSS, JS, images, documentation)
- **Size**: ~1.9 MB total
- **Backup Strategy**: 
  - Git version control (full history)
  - Timestamped tar.gz backups (created by `create-backup.sh`)
  - Manual `index copy.html` as emergency backup

### 2. GitHub (Remote Repository & Deployment)
- **Repository**: `https://github.com/sma11dragon/digital-fleet-prototype.git`
- **Purpose**: 
  - Version control and collaboration
  - GitHub Pages hosting (https://digitalfleet.daeit.com.sg)
  - Public deployment
- **Backup Strategy**:
  - Full git history with all commits
  - Automated deployments via `deploy-to-github.sh`
  - Live website serves as functional backup

### 3. NAS (Network-Attached Storage)
- **Status**: **Not currently configured** (see setup instructions below)
- **Purpose**: Offsite/network backup for disaster recovery
- **Recommended Setup**: Synology, QNAP, or any SMB/NFS share
- **Backup Strategy**: 
  - Scheduled sync of backup archives
  - Versioned backups retention

## 🔧 Backup Tools Created

### `create-backup.sh`
Creates timestamped backups with these features:
- Compressed tar.gz archives
- Excludes `.git` directory and existing backups
- Creates manifest of included files
- Keeps last 10 backups (auto-cleanup)
- Detailed logging and verification

### `restore-backup.sh`
Restores from backup archives:
- Safety backup before restore
- Verification of restored files
- Step-by-step confirmation
- Preserves git history

### Existing Backup Files
- `index copy.html`: Manual backup of main HTML file (134KB, older version)
- `.git`: Full version history (distributed backup)

## 📁 File Structure & Critical Files

```
digital-fleet-prototype/
├── index.html              # Main application (145KB) - CRITICAL
├── index copy.html         # Manual backup (134KB)
├── create-backup.sh        # Backup creation script
├── restore-backup.sh       # Restore script
├── backups/                # Backup archives (created automatically)
│   ├── digital-fleet-backup_20250204_162315.tar.gz
│   └── backup_20250204_162315_manifest.txt
├── deploy-to-github.sh     # Deployment to GitHub Pages
├── quick-deploy.sh         # Quick deployment
├── AGENTS.md              # Agent guidance documentation
├── CLAUDE.md              # Project overview
├── SKILL.md               # UI redesign guidelines
├── DEPLOYMENT-SETUP-GUIDE.md
├── CNAME                  # Custom domain configuration
├── *.png, *.svg, *.webp   # Image assets
└── .git/                  # Git repository (full history)
```

## 🚀 Backup Workflow

### Daily Development Workflow
```bash
# 1. Work on files locally
# 2. Test changes: open index.html in browser
# 3. Create backup before major changes
./create-backup.sh

# 4. Deploy to GitHub (also creates git backup)
./deploy-to-github.sh
```

### Recovery Scenarios

#### Scenario 1: Accidental file deletion/corruption
```bash
# List available backups
ls -la backups/

# Restore from latest backup
./restore-backup.sh digital-fleet-backup_20250204_162315.tar.gz

# Test restored site
open index.html
```

#### Scenario 2: Complete system failure
```bash
# From new machine:
git clone https://github.com/sma11dragon/digital-fleet-prototype.git
cd digital-fleet-prototype

# Optional: Restore from specific backup if needed
# (download backup from NAS or other storage first)
./restore-backup.sh <backup-file>
```

#### Scenario 3: Need to revert to specific version
```bash
# Use git to revert to specific commit
git log --oneline
git checkout <commit-hash>

# Or restore from timestamped backup
./restore-backup.sh digital-fleet-backup_<timestamp>.tar.gz
```

## 🗄️ NAS Setup Instructions

### Option A: Synology NAS (Recommended)
1. **Create shared folder**: `DAE_Digital_Fleet`
2. **Enable SMB/AFP/NFS** based on your OS
3. **Mount on Mac**:
   ```bash
   # Go > Connect to Server > smb://<nas-ip>/DAE_Digital_Fleet
   # Or mount via command line:
   mkdir -p ~/NAS
   mount_smbfs //user:password@<nas-ip>/DAE_Digital_Fleet ~/NAS
   ```

4. **Create sync script** (`sync-to-nas.sh`):
   ```bash
   #!/bin/bash
   BACKUP_SOURCE="/Users/siewloongchan/Documents/DAE - Operations/Countries/Malaysia/Digital Fleet/digital-fleet-prototype"
   NAS_MOUNT="$HOME/NAS/DAE_Digital_Fleet"
   
   # Sync backups directory
   rsync -av "$BACKUP_SOURCE/backups/" "$NAS_MOUNT/backups/"
   
   # Sync latest git state
   cd "$BACKUP_SOURCE" && git bundle create "$NAS_MOUNT/git-backup-$(date +%Y%m%d).bundle" --all
   ```

### Option B: Generic SMB/CIFS Share
```bash
#!/bin/bash
# sync-to-nas-generic.sh
LOCAL_DIR="/Users/siewloongchan/Documents/DAE - Operations/Countries/Malaysia/Digital Fleet/digital-fleet-prototype"
NAS_PATH="//<nas-ip>/share/DAE_Digital_Fleet"
MOUNT_POINT="/Volumes/DAE_Backup"

# Mount NAS (enter credentials when prompted)
mount -t smbfs "$NAS_PATH" "$MOUNT_POINT"

# Sync files
rsync -av --delete "$LOCAL_DIR/" "$MOUNT_POINT/" --exclude=".git" --exclude="backups"

# Create backup archive on NAS
cd "$LOCAL_DIR" && ./create-backup.sh
cp "$LOCAL_DIR/backups/"*.tar.gz "$MOUNT_POINT/backups/"

# Unmount when done
diskutil unmount "$MOUNT_POINT"
```

### Option C: Cloud Sync (Dropbox, Google Drive, OneDrive)
1. Create symlink from cloud folder to project:
   ```bash
   # Move backups to cloud-synced location
   mv backups ~/Dropbox/DAE_Digital_Fleet_backups/
   ln -s ~/Dropbox/DAE_Digital_Fleet_backups backups
   ```

2. Or sync entire project directory using cloud provider's sync tool

## 🔐 Backup Retention Policy

| Backup Type | Retention Period | Location | Purpose |
|-------------|-----------------|----------|---------|
| Git Commits | Permanent | GitHub + Local | Full version history |
| Local tar.gz | Last 10 backups | Local `backups/` | Quick recovery |
| NAS Archives | 30 days | NAS storage | Disaster recovery |
| Cloud Sync | Configurable | Cloud provider | Offsite backup |

## 🧪 Testing Backup & Restore

### Quarterly Test Procedure
1. **Create test backup**:
   ```bash
   ./create-backup.sh
   ```

2. **Simulate disaster**:
   ```bash
   # Move original files aside
   mkdir -p /tmp/dae-test-original
   mv *.html *.md *.sh *.png /tmp/dae-test-original/ 2>/dev/null || true
   ```

3. **Restore from backup**:
   ```bash
   ./restore-backup.sh digital-fleet-backup_$(date +%Y%m%d)*.tar.gz
   ```

4. **Verify restoration**:
   ```bash
   # Check critical files exist
   test -f index.html && echo "✓ index.html restored"
   test -f deploy-to-github.sh && echo "✓ deploy script restored"
   
   # Test website functionality
   open index.html
   ```

5. **Cleanup**:
   ```bash
   # Restore original files
   rm -rf *.html *.md *.sh *.png
   mv /tmp/dae-test-original/* .
   ```

## 📞 Emergency Recovery

### If All Backups Fail
1. **Download from GitHub**:
   ```bash
   git clone https://github.com/sma11dragon/digital-fleet-prototype.git
   ```

2. **Download live website** (last resort):
   ```bash
   wget --mirror --convert-links --adjust-extension --page-requisites \
        --no-parent https://digitalfleet.daeit.com.sg
   ```

### Critical Files Checklist
- [ ] `index.html` (main application)
- [ ] All image assets (`*.png`, `*.svg`, `*.webp`)
- [ ] Deployment scripts (`*.sh`)
- [ ] Documentation (`*.md`)
- [ ] `CNAME` file (custom domain)
- [ ] `.git/config` (repository settings)

## 🚨 Disaster Recovery Plan

### Step 1: Assess Damage
- What files are missing/corrupted?
- Is git repository intact?
- Are backups accessible?

### Step 2: Choose Recovery Method
1. **Minor issues**: Use `git checkout` or restore single files from backup
2. **Major corruption**: Use `./restore-backup.sh`
3. **Complete loss**: Clone from GitHub + restore latest backup

### Step 3: Verify Recovery
- Test website locally
- Check all functionality
- Deploy to GitHub Pages
- Update backups

## 🔄 Automation Recommendations

### Cron Job for Daily Backups
```bash
# Edit crontab: crontab -e
# Add line for daily backup at 2 AM:
0 2 * * * cd "/Users/siewloongchan/Documents/DAE - Operations/Countries/Malaysia/Digital Fleet/digital-fleet-prototype" && ./create-backup.sh >/tmp/dae-backup.log 2>&1
```

### Git Hooks for Auto-backup
```bash
# .git/hooks/pre-commit
#!/bin/bash
echo "Creating pre-commit backup..."
cd "/Users/siewloongchan/Documents/DAE - Operations/Countries/Malaysia/Digital Fleet/digital-fleet-prototype"
./create-backup.sh > /dev/null 2>&1
```

## 📊 Monitoring & Maintenance

### Monthly Checklist
- [ ] Verify backups are being created
- [ ] Test restore procedure
- [ ] Check NAS sync is working
- [ ] Review backup disk space
- [ ] Update documentation if needed

### Backup Health Indicators
- **Good**: Multiple backup files in `backups/` directory
- **Good**: Git history shows regular commits
- **Warning**: Only 1-2 backups available
- **Critical**: No backups in last 7 days

---

**Last Updated**: $(date)
**Backup System Version**: 1.0
**Responsible**: Development Team
**Emergency Contact**: Repository maintainer