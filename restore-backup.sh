#!/bin/bash

# DAE Digital Fleet - Restore Script
# Restores the project from a backup archive

# Color codes for better readability
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Project directory
PROJECT_DIR="/Users/siewloongchan/Documents/DAE - Operations/Countries/Malaysia/Digital Fleet/digital-fleet-prototype"
BACKUP_DIR="$PROJECT_DIR/backups"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}DAE Digital Fleet - Restore from Backup${NC}"
echo -e "${BLUE}========================================${NC}\n"

# Check if backup filename is provided
if [ -z "$1" ]; then
    echo -e "${YELLOW}Usage: $0 <backup_filename>${NC}"
    echo -e "${YELLOW}Example: $0 digital-fleet-backup_20250204_162315.tar.gz${NC}"
    echo -e "\n${YELLOW}Available backups:${NC}"
    ls -la "$BACKUP_DIR"/digital-fleet-backup_*.tar.gz 2>/dev/null || echo "No backups found in $BACKUP_DIR"
    echo ""
    exit 1
fi

BACKUP_FILENAME="$1"
BACKUP_PATH="$BACKUP_DIR/$BACKUP_FILENAME"

# Check if backup file exists
if [ ! -f "$BACKUP_PATH" ]; then
    echo -e "${RED}✗ Error: Backup file not found: $BACKUP_FILENAME${NC}"
    echo -e "${YELLOW}Available backups:${NC}"
    ls -la "$BACKUP_DIR"/digital-fleet-backup_*.tar.gz 2>/dev/null || echo "No backups found"
    echo ""
    exit 1
fi

echo -e "${YELLOW}→ Backup file: $BACKUP_FILENAME${NC}"
echo -e "${YELLOW}→ Backup size: $(du -h "$BACKUP_PATH" | cut -f1)${NC}"
echo -e "${YELLOW}→ Backup date: $(stat -f "%Sm" "$BACKUP_PATH")${NC}\n"

# Display backup contents
echo -e "${YELLOW}→ Backup contents preview:${NC}"
tar -tzf "$BACKUP_PATH" | head -10
echo -e "${YELLOW}  ... (and more)${NC}\n"

# Show current directory contents before restore
echo -e "${YELLOW}→ Current directory contents (before restore):${NC}"
ls -la "$PROJECT_DIR" | head -15
echo ""

# Safety confirmation
echo -e "${RED}⚠️  WARNING: This will overwrite existing files!${NC}"
read -p "Are you sure you want to restore from this backup? (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    echo -e "${YELLOW}Restore cancelled.${NC}"
    exit 0
fi

echo -e "\n${YELLOW}→ Creating safety backup of current state...${NC}"
SAFETY_BACKUP="$BACKUP_DIR/safety_backup_before_restore_$(date +%Y%m%d_%H%M%S).tar.gz"
cd "$PROJECT_DIR" && tar -czf "$SAFETY_BACKUP" \
    --exclude="./backups" \
    --exclude="./.git" \
    --exclude=".DS_Store" \
    .
echo -e "${GREEN}✓ Safety backup created: $(basename "$SAFETY_BACKUP")${NC}\n"

# Navigate to project directory
echo -e "${YELLOW}→ Navigating to project directory...${NC}"
cd "$PROJECT_DIR" || {
    echo -e "${RED}✗ Error: Could not navigate to project directory${NC}"
    exit 1
}

# Extract backup
echo -e "${YELLOW}→ Extracting backup...${NC}"
tar -xzf "$BACKUP_PATH"
echo -e "${GREEN}✓ Backup extracted${NC}\n"

# Verify extraction
echo -e "${YELLOW}→ Verifying restore...${NC}"
RESTORED_FILES=$(tar -tzf "$BACKUP_PATH" | wc -l)
echo -e "${GREEN}✓ $RESTORED_FILES files restored${NC}\n"

# Show after restore
echo -e "${YELLOW}→ Directory contents (after restore):${NC}"
ls -la "$PROJECT_DIR" | head -15
echo ""

# Summary
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}✓ Restore Complete!${NC}"
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Restore Details:${NC}"
echo -e "  Backup: $BACKUP_FILENAME"
echo -e "  Files restored: $RESTORED_FILES"
echo -e "  Timestamp: $(date)"
echo -e "  Safety backup: $(basename "$SAFETY_BACKUP")"
echo -e "\n${YELLOW}Next steps:${NC}"
echo -e "  1. Test the restored website: open index.html in browser"
echo -e "  2. Check all functionality works"
echo -e "  3. Deploy to GitHub if needed: ./deploy-to-github.sh"
echo -e "\n${RED}Important notes:${NC}"
echo -e "  • Git history is preserved (not affected by restore)"
echo -e "  • If git shows conflicts, run: git status"
echo -e "  • To undo this restore, use the safety backup"
echo -e "  • .git directory was not overwritten"
echo -e ""