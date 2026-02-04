#!/bin/bash

# DAE Digital Fleet - NAS Sync Script
# Syncs backups to NAS storage for disaster recovery

# Color codes for better readability
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration - EDIT THESE VALUES FOR YOUR NAS
PROJECT_DIR="/Users/siewloongchan/Documents/DAE - Operations/Countries/Malaysia/Digital Fleet/digital-fleet-prototype"
BACKUP_DIR="$PROJECT_DIR/backups"

# NAS Configuration - Choose one option below
# Option 1: Mounted NAS directory (already mounted)
# NAS_MOUNT="$HOME/NAS/DAE_Digital_Fleet"

# Option 2: SMB/CIFS share (script will mount it)
# NAS_SMB="//user:password@nas-ip/DAE_Digital_Fleet"
# NAS_MOUNT="/Volumes/DAE_Backup"

# Option 3: Local test directory (for testing)
NAS_MOUNT="$HOME/Desktop/DAE_NAS_Test"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}DAE Digital Fleet - NAS Sync${NC}"
echo -e "${BLUE}========================================${NC}\n"

# Check if NAS mount point exists
if [ ! -d "$NAS_MOUNT" ]; then
    echo -e "${YELLOW}→ Creating NAS mount directory: $NAS_MOUNT${NC}"
    mkdir -p "$NAS_MOUNT"
    echo -e "${GREEN}✓ Directory created${NC}\n"
    
    echo -e "${YELLOW}⚠️  NOTE: This is a test directory${NC}"
    echo -e "${YELLOW}For real NAS setup, edit this script and configure:${NC}"
    echo -e "${YELLOW}1. Uncomment NAS_SMB or NAS_MOUNT lines above${NC}"
    echo -e "${YELLOW}2. Set correct NAS credentials and paths${NC}\n"
fi

# Create directory structure on NAS
echo -e "${YELLOW}→ Creating NAS directory structure...${NC}"
mkdir -p "$NAS_MOUNT/backups"
mkdir -p "$NAS_MOUNT/git_backups"
mkdir -p "$NAS_MOUNT/documentation"
echo -e "${GREEN}✓ Directories created${NC}\n"

# Create new backup before syncing
echo -e "${YELLOW}→ Creating fresh backup...${NC}"
cd "$PROJECT_DIR" && ./create-backup.sh >/dev/null 2>&1
LATEST_BACKUP=$(ls -t "$BACKUP_DIR"/digital-fleet-backup_*.tar.gz 2>/dev/null | head -1)
if [ -f "$LATEST_BACKUP" ]; then
    echo -e "${GREEN}✓ Backup created: $(basename "$LATEST_BACKUP")${NC}"
else
    echo -e "${RED}✗ No backup found${NC}"
fi
echo ""

# Sync backup files to NAS
echo -e "${YELLOW}→ Syncing backup files to NAS...${NC}"
rsync -av --progress "$BACKUP_DIR/" "$NAS_MOUNT/backups/" --exclude="safety_backup_*"
echo -e "${GREEN}✓ Backups synced${NC}\n"

# Create git bundle for full history
echo -e "${YELLOW}→ Creating git bundle backup...${NC}"
cd "$PROJECT_DIR"
GIT_BUNDLE="$NAS_MOUNT/git_backups/digital-fleet-git-$(date +%Y%m%d).bundle"
git bundle create "$GIT_BUNDLE" --all
echo -e "${GREEN}✓ Git bundle created: $(basename "$GIT_BUNDLE")${NC}\n"

# Sync documentation
echo -e "${YELLOW}→ Syncing documentation...${NC}"
cp -v "$PROJECT_DIR"/*.md "$NAS_MOUNT/documentation/" 2>/dev/null || true
echo -e "${GREEN}✓ Documentation synced${NC}\n"

# Sync critical files individually
echo -e "${YELLOW}→ Syncing critical files...${NC}"
CRITICAL_FILES=("index.html" "deploy-to-github.sh" "restore-backup.sh" "create-backup.sh" "CNAME")
for file in "${CRITICAL_FILES[@]}"; do
    if [ -f "$PROJECT_DIR/$file" ]; then
        cp -v "$PROJECT_DIR/$file" "$NAS_MOUNT/"
        echo -e "  ✓ $file"
    fi
done
echo -e "${GREEN}✓ Critical files synced${NC}\n"

# Clean up old git bundles (keep last 5)
echo -e "${YELLOW}→ Cleaning old git bundles (keep last 5)...${NC}"
cd "$NAS_MOUNT/git_backups" && ls -t digital-fleet-git-*.bundle 2>/dev/null | tail -n +6 | xargs rm -f 2>/dev/null
echo -e "${GREEN}✓ Old bundles cleaned${NC}\n"

# Verify sync
echo -e "${YELLOW}→ Verifying NAS sync...${NC}"
echo "NAS Location: $NAS_MOUNT"
echo "Total backups on NAS: $(ls "$NAS_MOUNT/backups"/*.tar.gz 2>/dev/null | wc -l | tr -d ' ')"
echo "Latest backup: $(ls -t "$NAS_MOUNT/backups"/*.tar.gz 2>/dev/null | head -1 | xargs basename 2>/dev/null || echo 'None')"
echo "Git bundles: $(ls "$NAS_MOUNT/git_backups"/*.bundle 2>/dev/null | wc -l | tr -d ' ')"
echo ""

# Create sync report
SYNC_REPORT="$NAS_MOUNT/sync_report_$(date +%Y%m%d_%H%M%S).txt"
{
    echo "DAE Digital Fleet NAS Sync Report"
    echo "================================="
    echo "Date: $(date)"
    echo "Source: $PROJECT_DIR"
    echo "Destination: $NAS_MOUNT"
    echo ""
    echo "Backups synced:"
    ls -lh "$NAS_MOUNT/backups"/*.tar.gz 2>/dev/null || echo "No backups"
    echo ""
    echo "Git bundles:"
    ls -lh "$NAS_MOUNT/git_backups"/*.bundle 2>/dev/null || echo "No git bundles"
    echo ""
    echo "Critical files:"
    ls -lh "$NAS_MOUNT"/index.html "$NAS_MOUNT"/*.sh "$NAS_MOUNT"/CNAME 2>/dev/null || echo "No critical files"
} > "$SYNC_REPORT"

echo -e "${GREEN}✓ Sync report created: $(basename "$SYNC_REPORT")${NC}\n"

# Summary
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}✓ NAS Sync Complete!${NC}"
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Sync Summary:${NC}"
echo -e "  NAS Location: $NAS_MOUNT"
echo -e "  Backups: $(ls "$NAS_MOUNT/backups"/*.tar.gz 2>/dev/null | wc -l | tr -d ' ')"
echo -e "  Git bundles: $(ls "$NAS_MOUNT/git_backups"/*.bundle 2>/dev/null | wc -l | tr -d ' ')"
echo -e "  Documentation: $(ls "$NAS_MOUNT/documentation"/*.md 2>/dev/null | wc -l | tr -d ' ')"
echo -e "  Report: $(basename "$SYNC_REPORT")"
echo -e "\n${YELLOW}Next steps:${NC}"
echo -e "  1. For production use, edit this script with real NAS paths"
echo -e "  2. Schedule regular syncs via cron:"
echo -e "     0 3 * * * $PROJECT_DIR/sync-to-nas.sh"
echo -e "  3. Test recovery from NAS backup"
echo -e "\n${RED}Configuration needed:${NC}"
echo -e "  • Edit this script (lines 13-20) with your NAS details"
echo -e "  • For SMB/CIFS, uncomment NAS_SMB lines and add credentials"
echo -e "  • Test mount/unmount manually first"
echo -e ""