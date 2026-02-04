#!/bin/bash

# DAE Digital Fleet - Backup Script
# Creates timestamped backups of the entire project

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
echo -e "${BLUE}DAE Digital Fleet - Backup Creation${NC}"
echo -e "${BLUE}========================================${NC}\n"

# Navigate to project directory
echo -e "${YELLOW}→ Navigating to project directory...${NC}"
cd "$PROJECT_DIR" || {
    echo -e "${RED}✗ Error: Could not navigate to project directory${NC}"
    exit 1
}
echo -e "${GREEN}✓ Current directory: $(pwd)${NC}\n"

# Create backups directory if it doesn't exist
echo -e "${YELLOW}→ Creating backups directory...${NC}"
mkdir -p "$BACKUP_DIR"
echo -e "${GREEN}✓ Backups directory: $BACKUP_DIR${NC}\n"

# Create timestamp for backup filename
TIMESTAMP=$(date "+%Y%m%d_%H%M%S")
BACKUP_FILENAME="digital-fleet-backup_${TIMESTAMP}.tar.gz"
BACKUP_PATH="$BACKUP_DIR/$BACKUP_FILENAME"

# List files to be backed up
echo -e "${YELLOW}→ Files to be backed up:${NC}"
find . -type f ! -path "./backups/*" ! -path "./.git/*" ! -name ".DS_Store" | head -20
echo -e "${YELLOW}  ... (and more)${NC}\n"

# Create backup archive
echo -e "${YELLOW}→ Creating backup archive...${NC}"
tar -czf "$BACKUP_PATH" \
    --exclude="./backups" \
    --exclude="./.git" \
    --exclude=".DS_Store" \
    .
echo -e "${GREEN}✓ Backup created: $BACKUP_FILENAME${NC}\n"

# Calculate backup size
BACKUP_SIZE=$(du -h "$BACKUP_PATH" | cut -f1)
echo -e "${YELLOW}→ Backup size: ${BACKUP_SIZE}${NC}\n"

# Create backup manifest (list of files in backup)
MANIFEST_FILE="$BACKUP_DIR/backup_${TIMESTAMP}_manifest.txt"
echo -e "${YELLOW}→ Creating backup manifest...${NC}"
tar -tzf "$BACKUP_PATH" > "$MANIFEST_FILE"
echo -e "${GREEN}✓ Manifest created: $(basename "$MANIFEST_FILE")${NC}\n"

# Clean up old backups (keep last 10)
echo -e "${YELLOW}→ Cleaning up old backups (keeping last 10)...${NC}"
cd "$BACKUP_DIR" && ls -t digital-fleet-backup_*.tar.gz | tail -n +11 | xargs rm -f 2>/dev/null
cd "$BACKUP_DIR" && ls -t backup_*_manifest.txt | tail -n +11 | xargs rm -f 2>/dev/null
echo -e "${GREEN}✓ Old backups cleaned${NC}\n"

# List current backups
echo -e "${YELLOW}→ Current backups available:${NC}"
ls -lh "$BACKUP_DIR"/digital-fleet-backup_*.tar.gz 2>/dev/null || echo "No backups found"
echo ""

# Summary
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}✓ Backup Complete!${NC}"
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Backup Details:${NC}"
echo -e "  File: $BACKUP_FILENAME"
echo -e "  Size: $BACKUP_SIZE"
echo -e "  Location: $BACKUP_DIR"
echo -e "  Files in backup: $(tar -tzf "$BACKUP_PATH" | wc -l)"
echo -e "  Timestamp: $(date)"
echo -e "\n${YELLOW}To restore from this backup:${NC}"
echo -e "  ./restore-backup.sh $BACKUP_FILENAME"
echo -e "\n${YELLOW}To list all backups:${NC}"
echo -e "  ls -la backups/"
echo -e "\n${YELLOW}Important: This backup includes:${NC}"
echo -e "  • HTML/CSS/JS files"
echo -e "  • All images and assets"
echo -e "  • Documentation (AGENTS.md, CLAUDE.md, etc.)"
echo -e "  • Deployment scripts"
echo -e "  • Git configuration (excluding .git history)"
echo -e "\n${RED}Excluded from backup:${NC}"
echo -e "  • Existing backups directory"
echo -e "  • .git directory (use git clone for full history)"
echo -e "  • .DS_Store files"
echo -e ""